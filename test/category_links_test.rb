require "test_helper"

# Value: protects=no empty "in <category>" links for posts without a category (Lighthouse: links must have discernible text); fails_when=a layout prints the category link unconditionally again; why_new=no test covered post meta links; seam=none
class CategoryLinksTest < Minitest::Test
  def test_no_empty_category_links
    offenders = Dir[File.join(built_site, "**", "*.html")].select do |page|
      File.read(page).match?(%r{<a href=['"][^'"]*/category/['"]>\s*</a>})
    end

    assert_empty offenders.map { |page| page.delete_prefix("#{built_site}/") }
  end
end
