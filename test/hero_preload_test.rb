require "test_helper"

# Value: protects=the hero/sidebar photo (usually the LCP) is preloaded with high priority at the exact URL the CSS background uses; fails_when=a layout drops the preload or the two URLs drift apart, so the photo downloads twice or late; why_new=no test covers <head>-time discovery of CSS background images; seam=none
class HeroPreloadTest < Minitest::Test
  PAGES = {
    "homepage sidebar" => "index.html",
    "post hero" => "the-toolset.html",
    "page hero" => "about/index.html",
    "product hero" => "shop/ecm-main-pcb/index.html",
  }.freeze

  PAGES.each do |name, path|
    define_method("test_#{name.tr(" ", "_")}_is_preloaded") do
      html = File.read(File.join(built_site, path))
      preloads = html.scan(/<link rel="preload" as="image" href="([^"]+)" fetchpriority="high">/).flatten
      background = html[/background-image: url\('([^']+)'\)/, 1]

      refute_nil background, "no hero background on #{path}"
      assert_equal [background], preloads, "#{path} should preload exactly its hero image"
    end
  end

  # Value: protects=text and layout render before the icon font arrives; fails_when=the FontAwesome @font-face loses font-display (e.g. vendor CSS upgrade); why_new=no test inspects compiled CSS; seam=none
  def test_icon_font_does_not_block_rendering
    css = File.read(File.join(built_site, "css/main.css"))
    font_face = css[/@font-face\s*\{[^}]*FontAwesome[^}]*\}/m]

    refute_nil font_face
    assert_match(/font-display:\s*swap/, font_face)
  end

  # Value: protects=avatar proportions; fails_when=.user-icon loses object-fit and non-square avatars (guest.jpg is 576x720) are squashed into the 50px circle; why_new=no test covered avatar styling; seam=none
  def test_avatars_are_cropped_not_squashed
    css = File.read(File.join(built_site, "css/main.css"))

    assert_match(/\.user-icon\s*\{[^}]*object-fit:\s*cover/m, css)
  end

  # Value: protects=the author page bio avatar is a circle while bio photos keep their shape; fails_when=the avatar inherits .user-icon's 50px height (a 150x50 strip once cropped), or the square height leaks onto every .author-bio img and squashes bio photos; why_new=design review (both passes); seam=none
  def test_author_bio_avatar_is_square
    css = File.read(File.join(built_site, "css/main.css"))
    avatar = css.scan(/\.author-bio \.author-avatar\s*\{([^}]*)\}/m).flatten
    photos = css.scan(/\.author-bio img\s*\{([^}]*)\}/m).flatten

    assert_includes avatar.join, "height: 150px"
    assert_includes avatar.join, "height: 220px"
    refute_empty photos
    photos.each { |rule| refute_match(/height:/, rule) }
  end
end
