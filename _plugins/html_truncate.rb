module OpenSX70HtmlTruncate
  # Comments and script/style/textarea blocks are single opaque tokens; tags
  # may contain ">" inside quoted attribute values; a "<" that does not start
  # a tag is plain text.
  TOKEN = %r{
    (<!--.*?-->|<(script|style|textarea)\b.*?</\2\s*>|</?[a-zA-Z](?:[^>"']|"[^"]*"|'[^']*')*>|<[!?][^>]*>)
    |([^<]+|<)
  }mix
  VOID_ELEMENTS = %w[area base br col embed hr img input link meta source track wbr].freeze
  SPACE = /[\s\u00A0]+/

  # Like Liquid's `truncatewords`, but only counts words in text nodes and
  # never splits a tag. Plain `truncatewords` counts attribute values (e.g. an
  # image's alt text) as words and can cut an <img> in half, which breaks the
  # homepage post previews.
  def truncate_html_words(input, limit, ellipsis = "...")
    limit = limit.to_i
    words = 0
    open_tags = []
    output = +""
    # Once the budget is spent exactly, remember where the text ended. Any
    # further content (an image, another paragraph) means the input was cut.
    cut = nil

    input.to_s.scan(TOKEN) do |tag, raw_element, text|
      if cut && (tag ? !tag.start_with?("</") : word?(text))
        return close_truncated(output[0, cut[:length]], cut[:open_tags], ellipsis)
      end

      if tag
        output << tag
        next if raw_element

        name = tag[%r{\A</?([a-zA-Z][\w-]*)}, 1]&.downcase
        next if name.nil? || VOID_ELEMENTS.include?(name) || tag.match?(%r{["'\s]/>\z})

        if tag.start_with?("</")
          index = open_tags.rindex(name)
          open_tags.slice!(index..) if index
        else
          open_tags << name
        end
      else
        pieces = text.split(/(#{SPACE})/)
        remaining = limit - words
        text_words = pieces.count { |piece| word?(piece) }

        if text_words <= remaining
          output << text
          words += text_words
          cut ||= { length: output.length, open_tags: open_tags.dup } if words == limit
        else
          kept = 0
          pieces.each do |piece|
            break if kept == remaining && word?(piece)

            output << piece
            kept += 1 if word?(piece)
          end
          return close_truncated(output, open_tags, ellipsis)
        end
      end
    end

    open_tags.reverse_each { |name| output << "</#{name}>" }
    output
  end

  private

  def word?(text)
    !text.gsub(SPACE, "").empty?
  end

  def close_truncated(output, open_tags, ellipsis)
    output = output.sub(/#{SPACE}\z/, "") << ellipsis
    open_tags.reverse_each { |name| output << "</#{name}>" }
    output
  end
end

Liquid::Template.register_filter(OpenSX70HtmlTruncate)
