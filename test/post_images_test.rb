require "test_helper"
require File.join(ROOT, "_plugins/image_filters")

class PostImagesTest < Minitest::Test
  def body(path)
    html = File.read(File.join(built_site, path))
    html[%r{<h1>.*?</h1>(.*?)</div><!-- main-content/col -->}m, 1] || flunk("post body not found in #{path}")
  end

  # Value: protects=post and page photos download near their 269-749px column width; fails_when=post.html or page.html drops `image_sizes: "content"` and desktop falls back to the 1200px hint (a 1600w file for a 749px column); why_new=no test checked content sizes; seam=none
  def test_post_and_page_images_hint_the_content_column_width
    sizes = CGI.escapeHTML(OpenSX70ImageFilters::SIZES_PRESETS.fetch("content"))

    %w[a-look-inside-the-chips-on-the-sx-70-camera-t-i.html about/index.html].each do |path|
      sources = body(path).scan(/<source [^>]*>/)

      refute_empty sources, "no responsive images in #{path}"
      sources.each { |tag| assert_includes tag, %(sizes="#{sizes}") }
    end
  end

  # Value: protects=photos keep the size the original file rendered at; fails_when=responsive images lose their natural width attribute and small photos render at the density-derived width instead; why_new=width attribute is new; seam=none
  def test_responsive_images_keep_their_natural_width
    images = body("a-look-inside-the-chips-on-the-sx-70-camera-t-i.html").scan(%r{<picture>.*?</picture>}m).map { |picture| picture[/<img [^>]*>/] }

    refute_empty images
    images.each { |tag| assert_match(/\swidth="\d+"/, tag) }
  end
end
