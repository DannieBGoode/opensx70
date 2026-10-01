require "test_helper"

class HomepageTest < Minitest::Test
  def previews(path = "index.html")
    html = File.read(File.join(built_site, path))
    html[/<div class="home-page-posts.*?<div class="pagination/m] || flunk("homepage post list not found in #{path}")
  end

  # Every paginated homepage, so tests that look for a specific post keep
  # working as new posts push it off page 1.
  def all_previews
    pages = Dir[File.join(built_site, "page", "*", "index.html")].map { |path| path.delete_prefix("#{built_site}/") }
    (["index.html"] + pages).map { |path| previews(path) }.join
  end

  def test_post_previews_include_post_images
    refute_empty previews.scan(/<img\b[^>]*>/).reject { |tag| tag.include?("user-icon") }, "post previews lost their images"
    assert_includes all_previews, "/img/2025/zane.jpg"
  end

  def test_post_previews_do_not_split_image_tags
    assert_empty all_previews.scan(/<img\b[^>]*<\//), "an <img> tag was cut in half"
    assert_includes all_previews, %(alt="Zane spreading the openSX70 gospel at Polacon 2025 in NYC")
  end

  def test_post_previews_keep_paragraph_markup
    assert_match %r{<a href="/the-toolset">\s*<p>}, previews
  end

  # Value: protects=homepage previews stay short excerpts; fails_when=the layout drops `truncate_html_words` (or its limit) and every preview renders the full post, which the image/markup tests above still accept; why_new=no rendered-site test checks preview length; seam=none
  def test_post_previews_are_truncated_to_28_words
    bodies = previews.split('<article class="post">').drop(1).map do |article|
      article[%r{<span style="font-size:13px">.*?</span>(.*)<p class="read-more">}m, 1] || flunk("preview body not found")
    end

    refute_empty bodies
    bodies.each do |body|
      words = body.gsub(/<[^>]*>/, " ").split
      assert_operator words.size, :<=, 28, "preview has #{words.size} words: #{words.first(5).join(" ")}..."
    end
    assert bodies.any? { |body| body.gsub(/<[^>]*>/, " ").split.last&.end_with?("...") }, "no preview was truncated"
  end

  # Value: protects=PR #11 bandwidth intent without lazy-loading the first visible image; fails_when=later preview images load eagerly, or the eager slot is spent on a post without an image; why_new=no test checks loading attributes on restored previews; seam=none
  def test_only_the_first_preview_image_loads_eagerly
    images = previews.scan(/<img\b[^>]*>/).reject { |tag| tag.include?("user-icon") }

    refute_empty images
    refute_includes images.first, "loading=", "first preview image should load eagerly"
    images.drop(1).each { |tag| assert_includes tag, 'loading="lazy"' }
  end
end
