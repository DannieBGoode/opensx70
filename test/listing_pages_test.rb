require "test_helper"
require File.join(ROOT, "_plugins/image_filters")

# Value: protects=category and author listings render post excerpts with their HTML and images; fails_when=a layout strips excerpt markup again (as 11eba17 did); why_new=homepage_test.rb only covers index.html; seam=none
class ListingPagesTest < Minitest::Test
  PAGES = {
    "category" => "category/openSX70/index.html",
    "author" => "author/joaquin/index.html",
  }.freeze
  SIZES = { "category" => "post-preview", "author" => "author-preview" }.freeze

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

    # Value: protects=listing downloads match their preview column; fails_when=the layout drops its `image_sizes` preset and previews fall back to the 100vw/1200px hint; why_new=no test checked listing sizes; seam=none
    define_method("test_#{name}_previews_hint_their_column_width") do
      sources = previews(path).join.scan(/<source [^>]*>/)

      refute_empty sources, "no responsive preview images on #{path}"
      sizes = CGI.escapeHTML(OpenSX70ImageFilters::SIZES_PRESETS.fetch(SIZES.fetch(name)))
      sources.each { |tag| assert_includes tag, %(sizes="#{sizes}") }
    end
  end

  # Value: protects=the author page bio avatar and bio photos request their 150/220px display size; fails_when=author.html drops the author-avatar class or the "author-bio" preset and they fall back to the 60px avatar or 1200px default hint; why_new=pass-3 testing review; seam=none
  def test_author_bio_images_hint_their_display_size
    html = File.read(File.join(built_site, "author/joaquin/index.html"))
    bio = html[%r{<div class="author-bio">.*?<h2 class="favorites">}m] || flunk("author bio not found")
    sources = bio.scan(/<source [^>]*>/)

    assert_operator sources.size, :>=, 2, "expected the avatar and at least one bio photo"
    sources.each { |tag| assert_includes tag, %(sizes="(min-width: 992px) 220px, 150px") }
  end
end
