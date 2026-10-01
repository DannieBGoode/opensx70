require "test_helper"

# Value: protects=category and author listings render post excerpts with their HTML and images; fails_when=a layout strips excerpt markup again (as 11eba17 did); why_new=homepage_test.rb only covers index.html; seam=none
class ListingPagesTest < Minitest::Test
  PAGES = {
    "category" => "category/openSX70/index.html",
    "author" => "author/joaquin/index.html",
  }.freeze

  def previews(path)
    html = File.read(File.join(built_site, path))
    html.scan(/<div class="post-preview.*?<p class="meta">/m)
  end

  PAGES.each do |name, path|
    define_method("test_#{name}_previews_keep_excerpt_markup_and_images") do
      excerpts = previews(path)

      refute_empty excerpts, "no post previews on #{path}"
      assert excerpts.any? { |excerpt| excerpt.match?(/<img\b/) }, "#{name} previews lost their images"
      assert excerpts.any? { |excerpt| excerpt.include?("<p>") }, "#{name} previews lost paragraph markup"
      assert_empty excerpts.join.scan(/<img\b[^>]*<\//), "an <img> tag was cut in half on #{path}"
      images = excerpts.join.scan(/<img\b[^>]*>/)
      refute_includes images.first, "loading=", "first preview image on #{path} should load eagerly"
      images.drop(1).each { |tag| assert_includes tag, 'loading="lazy"' }
      excerpts.join.scan(/<iframe\b[^>]*>/).each { |tag| assert_includes tag, 'loading="lazy"' }
    end
  end
end
