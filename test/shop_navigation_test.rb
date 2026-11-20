require "test_helper"

class ShopNavigationTest < Minitest::Test
  def test_both_menus_link_to_the_storefront
    html = File.read(File.join(built_site, "index.html"))

    [%r{<div id="menu-target">.*?</div>}m, %r{<div class="no-js-menu clearfix">.*?</div>}m].each do |menu_pattern|
      menu = html[menu_pattern] || flunk("menu not rendered")
      assert_includes menu, '<a href="https://shop.opensx70.com">Shop</a>'
      refute_includes menu, ">Parts</a>"
    end
  end

  def test_the_old_catalog_is_no_longer_published
    refute File.exist?(File.join(built_site, "shop.html"))
    refute File.exist?(File.join(built_site, "shop"))
  end

  def test_preview_menus_prefix_internal_links_and_keep_external_links_absolute
    config = Jekyll.configuration("source" => ROOT, "baseurl" => "/preview", "quiet" => true)
    site = Jekyll::Site.new(config)

    %w[nav.html nav-no-js.html].each do |name|
      template = Liquid::Template.parse(File.read(File.join(ROOT, "_includes", name)))
      menu = template.render!(site.site_payload, registers: { site: site })

      assert_includes menu, '<a href="/preview/about">About</a>'
      assert_includes menu, '<a href="https://shop.opensx70.com">Shop</a>'
      assert_match %r{href="https://github.com/openSX70/openSX70-Arduino-main/wiki"[^>]*>WIKI</a>}, menu
      assert_includes menu, 'wiki" target="_blank">WIKI</a>' if name == "nav.html"
    end
  end
end
