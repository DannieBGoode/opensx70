require "minitest/autorun"
require "fileutils"
require "tmpdir"
require "jekyll"

ROOT = File.expand_path("..", __dir__)

# Builds the site once per test run, with the same image CDN setting Netlify
# uses in production, and returns the destination directory.
def built_site
  $built_site ||= begin
    destination = Dir.mktmpdir("opensx70-test-site")
    Minitest.after_run { FileUtils.remove_entry(destination) }
    previous_cdn = ENV["OPENSX70_USE_NETLIFY_IMAGE_CDN"]
    ENV["OPENSX70_USE_NETLIFY_IMAGE_CDN"] = "true"
    begin
      config = Jekyll.configuration("source" => ROOT, "destination" => destination, "quiet" => true)
      Jekyll::Site.new(config).process
    ensure
      ENV["OPENSX70_USE_NETLIFY_IMAGE_CDN"] = previous_cdn
    end
    destination
  end
end
