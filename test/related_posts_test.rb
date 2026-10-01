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

  # Value: protects=thumbnail sharpness; fails_when=the hint shrinks below the measured square cards (18vw desktop, 50vw+20px tablet, 100vw+30px mobile) or ignores that object-fit: cover shows landscape photos (band.jpg is 2.6:1) wider than the card; why_new=sizes_for had no test; seam=none
  def test_thumbnails_request_variants_for_their_real_width
    html = File.read(File.join(built_site, "the-toolset.html"))
    related = html[/<div class="row read-another-section">.*?<\/div>\s*<\/a>\s*<\/div>/m] || flunk("related posts section not found")

    assert_includes related, 'sizes="(min-width: 992px) 46.73vw, (min-width: 768px) calc(129.8vw + 51.92px), calc(259.6vw + 77.88px)"'
  end

  # Value: protects=external feature images used as thumbnails keep a valid URL; fails_when=site.baseurl is prepended to a full URL ("/subpathhttps://..."); why_new=the production baseurl is empty, so only an explicit check catches it; seam=none
  def test_external_thumbnails_are_not_prefixed
    sources = Dir[File.join(built_site, "**", "*.html")].flat_map do |page|
      File.read(page).scan(/class="related-thumbnail" src='([^']+)'/).flatten
    end

    refute_empty sources.grep(/\Ahttps?:/), "expected at least one external thumbnail in the build"
    assert_empty sources.grep(%r{\A/[^'"]*https?://})
  end
end
