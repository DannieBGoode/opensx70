require "cgi"
require "uri"

module OpenSX70ImageFilters
  IMAGE_TAG = /<img\b[^>]*>/i
  LAZY_MEDIA_TAG = /<(?:img|iframe)\b[^>]*>/i
  SRC_ATTRIBUTE = /\bsrc\s*=\s*(["'])(.*?)\1/im
  RESPONSIVE_EXTENSIONS = %w[.jpg .jpeg .png].freeze
  PUBLIC_MEDIA_PREFIXES = %w[/img/ /assets/uploads/].freeze
  RESPONSIVE_WIDTHS = [320, 800, 1600, 2400, 3200].freeze
  JPEG_QUALITY = 95

  class << self
    def enabled?
      ENV["OPENSX70_USE_NETLIFY_IMAGE_CDN"] == "true"
    end

    def source_path(source)
      source = CGI.unescapeHTML(source.to_s)
      source = source.split("?", 2).first.to_s.split("#", 2).first.to_s

      absolute_url = source.match(%r{\Ahttps?://([^/]+)(/.*)?\z}i)
      if absolute_url
        return nil unless %w[opensx70.com www.opensx70.com].include?(absolute_url[1].downcase)

        path = absolute_url[2]
      else
        path = source
      end

      path = path.to_s
      path = "/#{path}" unless path.start_with?("/")
      path = path.sub(%r{\A/+}, "/")
      return nil unless PUBLIC_MEDIA_PREFIXES.any? { |prefix| path.start_with?(prefix) }
      return nil unless RESPONSIVE_EXTENSIONS.include?(File.extname(path).downcase)

      path
    rescue URI::InvalidURIError
      nil
    end

    def encoded_path(path)
      path.split("/").map { |segment| URI.encode_www_form_component(segment) }.join("/")
    end

    def transformation_format(path)
      case File.extname(path).downcase
      when ".jpg", ".jpeg"
        ["webp", JPEG_QUALITY]
      when ".png"
        ["png", nil]
      end
    end

    def transformed_url(path, width, format_override = nil)
      format, quality = transformation_format(path)
      format = format_override if format_override
      quality = JPEG_QUALITY if format == "webp" || format == "jpg"
      return nil unless format

      url = "/.netlify/images?url=#{encoded_path(path)}&w=#{width}&fm=#{format}"
      url += "&q=#{quality}" if quality
      url
    end

    def transformed_srcset(input)
      path = source_path(input)
      return "" unless enabled? && path

      RESPONSIVE_WIDTHS.filter_map do |width|
        url = transformed_url(path, width)
        "#{url} #{width}w" if url
      end.join(", ")
    end

    def transformed_format(input)
      path = source_path(input)
      return "" unless enabled? && path

      transformation_format(path).first.to_s
    end

    def sizes_for(tag)
      case tag
      when /\bid\s*=\s*["'][^"']*product-main-image/i
        "(max-width: 768px) 100vw, 1200px"
      when /\bclass\s*=\s*["'][^"']*product-thumb/i
        "96px"
      when /\bclass\s*=\s*["'][^"']*(?:category-image|shop-card-image)/i
        "(max-width: 768px) 50vw, 320px"
      when /\bclass\s*=\s*["'][^"']*related-thumbnail/i
        # col-md-2 / col-sm-6 / full width below 768px (see footer-related-posts.html).
        "(min-width: 992px) 17vw, (min-width: 768px) 50vw, 100vw"
      else
        "(max-width: 768px) 100vw, 1200px"
      end
    end

    def responsive_tag(tag)
      return tag unless enabled?
      return tag if tag.match?(/\bsrcset\s*=/i)
      return tag if tag.match?(/\bclass\s*=\s*["'][^"']*user-icon/i)

      source_match = tag.match(SRC_ATTRIBUTE)
      return tag unless source_match

      path = source_path(source_match[2].to_s)
      return tag unless path

      format, = transformation_format(path)
      candidates = RESPONSIVE_WIDTHS.filter_map do |width|
        url = transformed_url(path, width)
        "#{url} #{width}w" if url
      end
      return tag if candidates.empty?

      srcset = CGI.escapeHTML(candidates.join(", "))
      sizes = CGI.escapeHTML(sizes_for(tag))
      if format == "webp"
        # Keep a CDN-sized JPEG fallback for browsers that do not support
        # <picture> or WebP. This preserves compatibility without making
        # those clients download the original source file.
        fallback_url = transformed_url(path, 2400, "jpg")
        fallback_tag = if fallback_url
                         tag.sub(source_match[0], source_match[0].sub(source_match[2], CGI.escapeHTML(fallback_url)))
                       else
                         tag
                       end
        "<picture><source type=\"image/webp\" srcset=\"#{srcset}\" sizes=\"#{sizes}\">#{fallback_tag}</picture>"
      else
        attributes = %( srcset="#{srcset}" sizes="#{sizes}")
        tag.sub(source_match[0], "#{source_match[0]}#{attributes}")
      end
    end

    def responsive_markup(input)
      return input.to_s unless enabled?

      input.to_s.gsub(IMAGE_TAG) { |tag| responsive_tag(tag) }
    end

    def netlify_image_url(input, width = 2400)
      source = input.to_s
      return source unless enabled?

      path = source_path(source)
      return source unless path

      # This helper is used where the browser cannot negotiate a <picture>
      # source, such as CSS backgrounds and the gallery's fallback `src`.
      # Keep those URLs universally decodable; responsive <img> markup still
      # offers WebP through its separate source element.
      format = transformation_format(path).first == "webp" ? "jpg" : nil
      transformed_url(path, width.to_i, format) || source
    end

    def netlify_image_srcset(input)
      transformed_srcset(input)
    end

    def netlify_image_format(input)
      transformed_format(input)
    end

    # Embeds (iframes) are always deferred; only the first image may stay
    # eager. Loading attributes never change which image variant is fetched.
    def add_lazy_attributes(input, eager_first = true)
      first_image = eager_first

      input.to_s.gsub(LAZY_MEDIA_TAG) do |tag|
        image = tag.match?(/\A<img\b/i)
        # `decoding` only applies to images.
        attributes = image ? ' loading="lazy" decoding="async"' : ' loading="lazy"'

        if first_image && image
          first_image = false
          tag
        elsif tag.match?(/\bloading\s*=/i)
          tag
        elsif tag.match?(%r{\s*/>\z})
          tag.sub(%r{\s*/>\z}, "#{attributes} />")
        else
          tag.sub(/>\z/, "#{attributes}>")
        end
      end
    end
  end

  # Leaves the first image eager (the likely LCP image) unless `eager_first`
  # is false, e.g. for listing previews below the first post.
  def lazy_images(input, eager_first = true)
    OpenSX70ImageFilters.add_lazy_attributes(input, eager_first)
  end

  def netlify_image_url(input, width = 2400)
    OpenSX70ImageFilters.netlify_image_url(input, width)
  end

  def netlify_image_srcset(input)
    OpenSX70ImageFilters.netlify_image_srcset(input)
  end

  def netlify_image_format(input)
    OpenSX70ImageFilters.netlify_image_format(input)
  end
end

Liquid::Template.register_filter(OpenSX70ImageFilters)

# Posts are also exposed as documents by Jekyll, so registering both :posts and
# :documents would apply the transformation twice and nest <picture> elements.
# The document hook covers posts and collection documents; pages need their own
# hook.
%i[pages documents].each do |hook_type|
  Jekyll::Hooks.register hook_type, :post_render do |item|
    item.output = OpenSX70ImageFilters.responsive_markup(item.output)
  end
end
