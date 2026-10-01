require "test_helper"

# Value: protects=the "read another" cards at the bottom of posts show a real thumbnail; fails_when=posts without square_related fall back to "/img/.jpg" again (broken image, cards collapse to 10px and titles overlap the author block); why_new=no test covers the related-posts footer; seam=none
class RelatedPostsTest < Minitest::Test
  def thumbnails
    html = File.read(File.join(built_site, "the-toolset.html"))
    html.scan(/<img class="related-thumbnail"[^>]*>/)
  end

  def test_every_related_card_has_a_real_image
    sources = thumbnails.map { |tag| tag[/\bsrc='([^']+)'/, 1] || tag[/\bsrc="([^"]+)"/, 1] }

    assert_equal 6, sources.size
    sources.each do |src|
      refute_match %r{/img/\.jpg}, src
      next if src.start_with?("http", "/.netlify/images")

      assert File.exist?(File.join(built_site, src)), "missing related thumbnail #{src}"
    end
  end

  # Value: protects=thumbnail sharpness; fails_when=the related-thumbnail sizes hint shrinks back to a fixed 200px and tablet/mobile cards (50-100vw) get a blurry 320w variant; why_new=sizes_for had no test; seam=none
  def test_thumbnails_request_variants_for_their_real_width
    html = File.read(File.join(built_site, "the-toolset.html"))
    related = html[/<div class="row read-another-section">.*?<\/div>\s*<\/a>\s*<\/div>/m] || flunk("related posts section not found")

    assert_includes related, 'sizes="(min-width: 992px) 17vw, (min-width: 768px) 50vw, 100vw"'
  end
end
