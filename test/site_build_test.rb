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
end
