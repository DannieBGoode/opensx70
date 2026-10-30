require_relative "test_helper"

class PostPosterTest < Minitest::Test
  def test_cms_poster_updates_article_headers_and_related_cards_without_legacy_fields
    Dir.mktmpdir("opensx70-poster-test") do |destination|
      config = Jekyll.configuration("source" => ROOT, "destination" => destination, "quiet" => true, "baseurl" => "/preview")
      site = Jekyll::Site.new(config)
      site.read
      latest = site.posts.docs.find { |post| post.basename_without_ext == "2025-09-02-the-toolset" }
      sidebar = site.posts.docs.find { |post| post.basename_without_ext == "2024-04-11-dolores-and-the-sx-70-the-sad-epilog" }
      latest.data["image"] = "/img/2025/band.jpg"
      latest.data.delete("feature_image")
      latest.data.delete("netlifycms")
      sidebar.data["image"] = "https://example.com/poster.jpg"
      sidebar.data["layout"] = "post-sidebar"
      sidebar.data.delete("feature_image")
      site.generate
      site.render
      site.write

      html = File.read(File.join(destination, "the-toolset.html"))
      assert_includes html, "background-image: url('/preview/img/2025/band.jpg')"
      assert_includes html, 'rel="preload" as="image" href="/preview/img/2025/band.jpg"'
      sidebar_html = File.read(File.join(destination, "dolores-and-the-sx-70-the-sad-epilog.html"))
      assert_includes sidebar_html, "background-image: url('https://example.com/poster.jpg')"
      related = sidebar_html[%r{<a href="/preview/the-toolset"><div.*?</a>}m]
      refute_nil related
      assert_includes related, "src='/preview/img/2025/band.jpg'"
    end
  end
end
