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
end
