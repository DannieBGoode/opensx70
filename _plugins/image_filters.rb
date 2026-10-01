require "cgi"
require "strscan"
require "uri"
require_relative "image_dimensions"

module OpenSX70ImageFilters
  IMAGE_TAG = /<img\b[^>]*>/i
  LAZY_MEDIA_TAG = /<(?:img|iframe)\b[^>]*>/i
  # One attribute and its (optionally quoted) value, matched at the scanner's
  # position: quoted values are consumed whole, so text inside alt="..." is
  # never read as an attribute, and matching stays linear in the tag length.
  ATTRIBUTE_TOKEN = /(?<ws>\s+)(?<name>[^\s"'=<>\/]+)(?:(?<eq>\s*=\s*)(?:"(?<dq>[^"]*)"|'(?<sq>[^']*)'|(?<uq>[^\s"'>]+)))?/
  RESPONSIVE_EXTENSIONS = %w[.jpg .jpeg .png].freeze
  PUBLIC_MEDIA_PREFIXES = %w[/img/ /assets/uploads/].freeze
  # Close steps keep each download near its display size; browsers still pick
  # a variant at least as wide as the slot's device pixels.
  RESPONSIVE_WIDTHS = [320, 400, 480, 560, 640, 800, 960, 1200, 1600, 2400, 3200, 4000, 4800].freeze
  JPEG_QUALITY = 95
  DEFAULT_SIZES = "(max-width: 768px) 100vw, 1200px"
  # Widths below were measured in Chromium at 320-2560px viewports and rounded
  # up, so the hint is never narrower than the image actually displays.
  # Full-width cards in the main column (homepage tutorials tab, author
  # listings, home-alt layouts).
  MAIN_COLUMN_SIZES = "(min-width: 1200px) 600px, (min-width: 992px) 490px, (min-width: 768px) calc(100vw - 220px), 100vw"
  # Author page bio: the avatar and photos (.author-bio img, see _author.sass).
  AUTHOR_BIO_SIZES = "(min-width: 992px) 220px, 150px"
  # Applied by layouts through the `image_sizes` filter.
  SIZES_PRESETS = {
    # .post-preview.col-xs-10 on the homepage and category listings.
    "post-preview" => "(min-width: 1200px) 500px, (min-width: 992px) 410px, (min-width: 768px) calc(84vw - 186px), calc(84vw - 50px)",
    "author-preview" => MAIN_COLUMN_SIZES,
    # Photos in the author page bio (.author-bio img).
    "author-bio" => AUTHOR_BIO_SIZES,
    # Post and page bodies (.single-content).
    "content" => "(min-width: 1200px) 750px, (min-width: 992px) 700px, (min-width: 768px) 640px, 85vw",
  }.freeze

  # An <img> tag split into attribute tokens, so it can be edited and rebuilt
  # without regexes over the raw markup.
  ImgTag = Struct.new(:tokens, :close) do
    def find(name)
      tokens.find { |token| token.name.casecmp?(name) }
    end

    def [](name)
      find(name)&.value
    end

    def key?(name)
      !find(name).nil?
    end

    def without(name)
      ImgTag.new(tokens.reject { |token| token.name.casecmp?(name) }, close)
    end

    def to_s
      "<img#{tokens.join}#{close}"
    end
  end

  AttributeToken = Struct.new(:ws, :name, :eq, :quote, :value) do
    def self.build(name, value)
      new(" ", name, "=", '"', value)
    end

    def with_value(value)
      AttributeToken.new(ws, name, eq || "=", quote.empty? ? '"' : quote, value)
    end

    def to_s
      eq ? "#{ws}#{name}#{eq}#{quote}#{value}#{quote}" : "#{ws}#{name}"
    end
  end

  class << self
    attr_writer :source_dir

    def enabled?
      ENV["OPENSX70_USE_NETLIFY_IMAGE_CDN"] == "true"
    end

    def source_dir
      @source_dir || Dir.pwd
    end

    def natural_width(path)
      natural_size(path)&.first
    end

    def natural_size(path)
      size = read_natural_size(path)
      warn_unknown_size(path) unless size
      size
    end

    def read_natural_size(path)
      root = File.realpath(source_dir)
      file = File.expand_path(File.join(root, path))
      file = File.expand_path(File.join(root, decode_path(path))) unless File.file?(file)
      return nil unless File.file?(file)

      # Never read outside the site source ("/img/../../x.jpg" or a symlink).
      file = File.realpath(file)
      return nil unless file.start_with?("#{root}#{File::SEPARATOR}")

      OpenSX70ImageDimensions.size(file)
    rescue SystemCallError, ArgumentError, EncodingError
      # Unreadable files, and paths with NUL bytes or invalid encodings.
      nil
    end

    # A bare "%" is not valid percent-encoding; keep the path as written.
    def decode_path(path)
      URI.decode_uri_component(path)
    rescue ArgumentError
      path
    end

    # Unknown sizes fall back to the uncapped ladder without a width attribute;
    # say so once per image instead of degrading silently.
    def warn_unknown_size(path)
      @warned ||= {}
      return if @warned[path]

      @warned[path] = true
      Jekyll.logger.warn("Image CDN:", "cannot read the size of #{path.inspect}; using the full width ladder")
    end

    # Parses an <img> tag; nil for markup that is not plain attributes, which
    # callers then leave untouched.
    def parse_tag(tag)
      return nil unless tag.match?(/\A<img\b/i) && tag.end_with?(">")

      body = tag[4...-1]
      slash = body.end_with?("/") ? "/" : ""
      body = body.delete_suffix(slash)
      attributes = body.rstrip
      close = "#{body[attributes.length..]}#{slash}>"

      scanner = StringScanner.new(attributes)
      tokens = []
      until scanner.eos?
        return nil unless scanner.scan(ATTRIBUTE_TOKEN)

        quote = if scanner[:dq] then '"' elsif scanner[:sq] then "'" else "" end
        value = scanner[:dq] || scanner[:sq] || scanner[:uq]
        tokens << AttributeToken.new(scanner[:ws], scanner[:name], scanner[:eq], quote, value)
      end
      ImgTag.new(tokens, close)
    end

    # Real attributes of a tag, by lowercase name ({} for unparseable markup).
    def attributes(tag)
      img = parse_tag(tag)
      return {} unless img

      img.tokens.reverse.to_h { |token| [token.name.downcase, token.value.to_s] }
    end

    # True when the tag sets its own width or height (attribute or inline CSS),
    # in which case adding the natural width would stretch it.
    def sized?(img)
      return true if img.key?("width") || img.key?("height")

      style = strip_css_comments(CGI.unescapeHTML(img["style"].to_s))
      style.match?(/(?:\A|;)\s*(?:width|height)\s*:/i)
    end

    def strip_css_comments(css)
      out = +""
      position = 0
      while (start = css.index("/*", position))
        out << css[position...start]
        finish = css.index("*/", start + 2)
        return out unless finish

        position = finish + 2
      end
      out << css[position..]
    end

    # Widths past the source add no detail and mislabel the variant, which makes
    # browsers shrink the photo; offer the source width itself instead.
    def candidate_widths(path)
      natural = natural_width(path)
      return RESPONSIVE_WIDTHS unless natural

      # Always end on the full source, so large screens and cover crops can
      # still get every pixel the original has.
      RESPONSIVE_WIDTHS.select { |width| width < natural } << natural
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
    rescue URI::InvalidURIError, ArgumentError, EncodingError
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

      # Without `w` the CDN keeps the source's own size (no resize limit applies).
      url = "/.netlify/images?url=#{encoded_path(path)}#{"&w=#{width}" if width}&fm=#{format}"
      url += "&q=#{quality}" if quality
      url
    end

    def transformed_srcset(input)
      path = source_path(input)
      return "" unless enabled? && path

      natural = natural_width(path)
      candidate_widths(path).filter_map do |width|
        url = transformed_url(path, width == natural ? nil : width)
        "#{url} #{width}w" if url
      end.join(", ")
    end

    def transformed_format(input)
      path = source_path(input)
      return "" unless enabled? && path

      transformation_format(path).first.to_s
    end

    # Images whose class or id fixes their display width. The third value
    # describes an object-fit: cover box (:square, or its fixed height in px):
    # wider photos are cropped, so they display wider than the box.
    CLASS_SIZES = [
      [:id, "product-main-image",
       "(min-width: 992px) 465px, (min-width: 768px) 580px, calc(84vw - 45px)", nil],
      [:class, "product-thumb",
       "(min-width: 992px) 145px, (min-width: 768px) 185px, calc(28vw - 25px)", 84],
      # A lone product card stretches across the whole auto-fit grid.
      [:class, "shop-card-image-solo", SIZES_PRESETS.fetch("content"), 235],
      # auto-fit minmax(280px, 1fr) grid on /shop.
      [:class, "shop-card-image",
       "(min-width: 1200px) 370px, (min-width: 992px) 340px, (min-width: 768px) 310px, calc(84vw + 12px)", 235],
      [:class, "category-image", MAIN_COLUMN_SIZES, nil],
      # col-md-2 / col-sm-6 / full width below 768px (see footer-related-posts.html);
      # the row's negative margins make cards slightly wider than those columns.
      [:class, "related-thumbnail",
       "(min-width: 992px) 18vw, (min-width: 768px) calc(50vw + 20px), calc(100vw + 30px)", :square],
      # The author page bio (see _author.sass).
      [:class, "author-avatar", AUTHOR_BIO_SIZES, :square],
      [:class, "user-icon", "60px", :square],
    ].freeze

    # Matches exact class tokens / id of the real attributes.
    def class_sizes(tag)
      attrs = attributes(tag)
      classes = CGI.unescapeHTML(attrs["class"].to_s).split
      id = CGI.unescapeHTML(attrs["id"].to_s).strip
      CLASS_SIZES.find { |kind, name, _sizes, _cover| kind == :id ? id == name : classes.include?(name) }
    end

    # `size` is the source's [width, height], used to widen cover-cropped hints.
    def sizes_for(tag, size = nil)
      _kind, _name, sizes, cover = class_sizes(tag)
      return DEFAULT_SIZES unless sizes

      cover_sizes(sizes, cover, size)
    end

    def cover_sizes(sizes, cover, size)
      return sizes unless cover && size && size[1].to_i.positive?

      aspect = size[0].to_f / size[1]
      sizes.split(/,\s*(?![^()]*\))/).map do |entry|
        condition, length = entry.match(/\A(\([^()]*\))\s+(.+)\z/)&.captures || [nil, entry]
        length = if cover == :square
                   aspect > 1 ? "calc(#{length} * #{(aspect * 1000).ceil / 1000.0})" : length
                 else
                   needed = (cover * aspect).ceil
                   fixed = length[/\A(\d+)px\z/, 1]&.to_i
                   fixed ? "#{[fixed, needed].max}px" : "max(#{length}, #{needed}px)"
                 end
        [condition, length].compact.join(" ")
      end.join(", ")
    end

    def responsive_tag(tag)
      return tag unless enabled?

      img = parse_tag(tag)
      return tag unless img
      # Already responsive, or lazy-loader markup that manages its own sources.
      return tag if img.key?("srcset") || img.key?("data-src") || img.key?("data-srcset")

      path = img["src"] && source_path(img["src"])
      return tag unless path

      format, = transformation_format(path)
      natural = natural_width(path)
      candidates = candidate_widths(path).filter_map do |width|
        url = transformed_url(path, width == natural ? nil : width)
        "#{url} #{width}w" if url
      end
      return tag if candidates.empty?

      srcset = CGI.escapeHTML(candidates.join(", "))
      reused = img["sizes"] && CGI.unescapeHTML(img["sizes"]).strip
      # Re-escape a reused value: it may have been single-quoted and contain `"`.
      # An empty sizes="" would mean 100vw, so it falls back to the class hint.
      sizes = CGI.escapeHTML(reused.to_s.empty? ? sizes_for(tag, natural_size(path)) : reused)
      img = img.without("sizes")
      # With w descriptors the browser derives the image's width from `sizes`;
      # the natural width keeps it at the size the original file rendered at.
      img.tokens << AttributeToken.build("width", natural.to_s) if natural && !sized?(img)

      if format == "webp"
        # Keep a CDN-sized JPEG fallback for browsers that do not support
        # <picture> or WebP. This preserves compatibility without making
        # those clients download the original source file.
        fallback_url = transformed_url(path, 2400, "jpg")
        if fallback_url
          src = img.find("src")
          img.tokens[img.tokens.index(src)] = src.with_value(CGI.escapeHTML(fallback_url))
        end
        "<picture><source type=\"image/webp\" srcset=\"#{srcset}\" sizes=\"#{sizes}\">#{img}</picture>"
      else
        position = img.tokens.index(img.find("src")) + 1
        img.tokens.insert(position, AttributeToken.build("srcset", srcset), AttributeToken.build("sizes", sizes))
        img.to_s
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

    # Only images that get CDN variants and have no class-specific hint.
    def add_sizes(input, preset)
      # Look the preset up first so a typo fails every build, not just the CDN one.
      sizes = CGI.escapeHTML(SIZES_PRESETS.fetch(preset))
      return input.to_s unless enabled?

      input.to_s.gsub(IMAGE_TAG) do |tag|
        img = parse_tag(tag)
        next tag unless img
        next tag if img.key?("srcset") || img.key?("data-src") || img.key?("data-srcset")
        # An empty sizes="" says nothing; replace it with the preset.
        next tag unless img["sizes"].to_s.strip.empty?
        next tag if img["src"].nil? || source_path(img["src"]).nil?
        next tag if class_sizes(tag)

        img = img.without("sizes")
        img.tokens.unshift(AttributeToken.build("sizes", sizes))
        img.to_s
      end
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

  # Tells the image CDN markup how wide these images display, using a named
  # preset from SIZES_PRESETS (e.g. "content", "post-preview").
  def image_sizes(input, preset)
    OpenSX70ImageFilters.add_sizes(input, preset)
  end
end

Liquid::Template.register_filter(OpenSX70ImageFilters)

Jekyll::Hooks.register :site, :after_init do |site|
  OpenSX70ImageFilters.source_dir = site.source
end

# `jekyll serve` keeps the plugin loaded; re-read images replaced in place.
Jekyll::Hooks.register :site, :after_reset do
  OpenSX70ImageDimensions.reset!
end

# Posts are also exposed as documents by Jekyll, so registering both :posts and
# :documents would apply the transformation twice and nest <picture> elements.
# The document hook covers posts and collection documents; pages need their own
# hook.
%i[pages documents].each do |hook_type|
  Jekyll::Hooks.register hook_type, :post_render do |item|
    item.output = OpenSX70ImageFilters.responsive_markup(item.output)
  end
end
