require_relative "test_helper"

class AdminTest < Minitest::Test
  def test_cms_entrypoint_does_not_use_unbundled_imports_in_classic_scripts
    html = File.read(File.join(built_site, "admin/index.html"))
    html.scan(/<script\b([^>]*)>(.*?)<\/script>/m).each do |attributes, script|
      next if attributes.match?(/\bsrc\s*=/) || attributes.match?(/\btype=["']module["']/)

      refute_match(/^\s*import\s/m, script,
                   "Classic scripts cannot import npm packages in the browser")
    end
    assert_includes html, 'src="https://identity.netlify.com/v1/netlify-identity-widget.js"'
    assert_includes html, 'src="https://unpkg.com/decap-cms@3.17.3/dist/decap-cms.js"'
    refute_match(%r{https://unpkg\.com/netlify-cms@}, html)
  end

  def test_cms_configuration_is_published_without_jekyll_expanding_path_templates
    assert_equal File.read(File.join(ROOT, "admin/config.yml")),
                 File.read(File.join(built_site, "admin/config.yml"))
  end
end
