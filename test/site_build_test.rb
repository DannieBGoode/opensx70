require "test_helper"

class SiteBuildTest < Minitest::Test
  def test_development_files_are_not_published
    %w[Rakefile test CLAUDE.md TESTING.md].each do |path|
      refute File.exist?(File.join(built_site, path)), "#{path} should be excluded from the site"
    end
  end

  # Value: protects=pages do not load the retired Universal Analytics tag (Google stopped processing UA data in 2023); fails_when=the gtag include or a UA- ID is reintroduced; why_new=no test inspects third-party scripts; seam=none
  def test_retired_google_analytics_is_not_loaded
    pages = Dir[File.join(built_site, "**", "*.html")]

    refute_empty pages
    offenders = pages.select { |page| File.read(page).match?(/googletagmanager\.com|google-analytics\.com|UA-\d+-\d+/) }
    assert_empty offenders.map { |page| page.delete_prefix("#{built_site}/") }
  end

  # Value: protects=the 7-day /css/* cache never serves stale CSS after a deploy; fails_when=head.html drops the per-build query string on main.css; why_new=testing review; seam=none
  def test_main_css_url_changes_every_build
    html = File.read(File.join(built_site, "index.html"))

    assert_match(%r{href="/css/main\.css\?\d+"}, html)
  end

  # Value: protects=repeat visits reuse vendor scripts, fonts and CSS instead of revalidating each one (PageSpeed "efficient cache policy"); fails_when=a header block is dropped from netlify.toml; why_new=no test covered netlify.toml headers; seam=none
  def test_static_assets_are_cacheable
    toml = File.read(File.join(ROOT, "netlify.toml"))

    %w[/img/* /js/vendor/* /fonts/* /css/*].each do |pattern|
      assert_match(/for = "#{Regexp.escape(pattern)}"\s*\[headers\.values\]\s*Cache-Control = "public, max-age=604800/m, toml)
    end
  end
end
