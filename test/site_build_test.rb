require "test_helper"

class SiteBuildTest < Minitest::Test
  def test_development_files_are_not_published
    %w[Rakefile test CLAUDE.md TESTING.md].each do |path|
      refute File.exist?(File.join(built_site, path)), "#{path} should be excluded from the site"
    end
  end
end
