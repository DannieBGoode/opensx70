require_relative "test_helper"
require "yaml"
require "date"

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

  def cms_collections
    YAML.load_file(File.join(ROOT, "admin/config.yml"), aliases: true).fetch("collections")
  end

  def test_flat_blog_can_discover_every_existing_markdown_file
    blog = cms_collections.find { |collection| collection["name"] == "blog" }
    refute blog.key?("nested"), "Blog navigation should be a flat list"
    # Decap's folder backend derives recursive listing depth from path segments.
    listing_depth = blog.fetch("path").split("/").length
    posts = Dir.glob(File.join(ROOT, blog.fetch("folder"), "**/*.md"))
    refute_empty posts
    posts.each do |path|
      relative = path.delete_prefix(File.join(ROOT, blog.fetch("folder")))
      assert_operator relative.split("/").length, :<=, listing_depth,
                      "#{relative} would disappear from the CMS listing"
    end
    sort = blog.fetch("sortable_fields").find { |field| field.is_a?(Hash) && field["default_sort"] }
    assert_equal "date", sort["field"]
    assert_equal "desc", sort["default_sort"]
  end

  def test_curated_pages_keep_authors_and_code_out_of_routine_editing
    assert_equal ["Blog posts", "Tutorials", "Parts", "Site pages", "Authors", "Settings"],
                 cms_collections.map { |collection| collection["label"] }
    pages = cms_collections.find { |collection| collection["name"] == "pages" }
    authors = cms_collections.find { |collection| collection["name"] == "authors" }
    assert_equal ["_pages/about.md", "_pages/faq.md", "_pages/links.md", "_pages/press.md", "files.md", "_pages/contact.md"],
                 pages.fetch("files").map { |file| file["file"] }
    assert_equal ["_pages/author-joaquin.md", "_pages/author-guest.md"],
                 authors.fetch("files").map { |file| file["file"] }

    [pages, authors].each do |collection|
      refute collection.fetch("delete")
      refute collection.key?("folder"), "Fixed pages should not offer arbitrary new pages"
      collection.fetch("files").each do |file|
        path = File.join(ROOT, file.fetch("file"))
        assert File.file?(path), "#{file['file']} is not an existing page"
        frontmatter = YAML.safe_load(File.read(path).split(/^---\s*$\n?/, 3)[1], permitted_classes: [Date, Time])
        fields = file.fetch("fields").to_h { |field| [field.fetch("name"), field] }
        %w[layout permalink].each do |name|
          assert_equal "hidden", fields.fetch(name).fetch("widget")
          refute fields.fetch(name).key?("default"), "Existing #{name} must not be overwritten"
          refute_empty frontmatter.fetch(name)
        end
        assert_equal "string", fields.fetch("feature_image").fetch("widget"),
                     "Legacy page headers need image names, not uploaded URLs"
        refute fields.fetch("description", {}).fetch("required", false)
        if collection["name"] == "pages"
          assert_equal "hidden", fields.fetch("published").fetch("widget"),
                       "Legacy pages without a published flag must not look unpublished"
          refute fields.fetch("published").key?("default")
        else
          assert_equal "hidden", fields.fetch("author_avatar").fetch("widget"),
                       "The author photo value also identifies the profile's post list"
          refute fields.fetch("author_avatar").key?("default")
        end
      end
    end
  end

  def test_new_tutorials_still_require_a_header_image
    tutorials = cms_collections.find { |collection| collection["name"] == "tutorials" }
    header = tutorials.fetch("fields").find { |field| field["name"] == "feature_image" }
    assert_equal true, header.fetch("required", true)
    Dir.glob(File.join(ROOT, "_tutorials/*.md")).each do |path|
      frontmatter = YAML.safe_load(File.read(path).split(/^---\s*$\n?/, 3)[1], permitted_classes: [Date, Time])
      refute_empty frontmatter.fetch("feature_image"), "#{path} must remain editable"
    end
  end

  def test_blog_dates_sort_chronologically_and_grid_has_a_recognized_image_field
    blog = cms_collections.find { |collection| collection["name"] == "blog" }
    poster = blog.fetch("fields").find { |field| field["name"] == "image" }
    assert_equal "image", poster.fetch("widget"), "Decap infers grid thumbnails from its recognized image field names"
    assert_equal({"field" => "layout", "value" => "post"}, blog.fetch("filter"))
    date_field = blog.fetch("fields").find { |field| field["name"] == "date" }
    assert_equal true, date_field.fetch("picker_utc")
    assert_equal "YYYY-MM-DDTHH:mm:ss.SSS[+00:00]", date_field.fetch("format")

    posts = Dir.glob(File.join(ROOT, "_posts/**/*.md")).filter_map do |path|
      content = File.read(path)
      next unless content.start_with?("---")
      data = YAML.safe_load(content.split(/^---\s*$\n?/, 3)[1], permitted_classes: [Date, Time])
      next unless data["layout"] == "post"

      date = content[/^date: ["']?([^"'\r\n]+)["']?\r?$/, 1]
      assert_match(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}\+00:00\z/, date,
                   "#{path}: CMS dates need the same UTC format, including after a save")
      if data["image"]
        assert_match(%r{\A(?:/img/|/assets/uploads/|https?://)}, data["image"], "#{path}: poster must be a public image URL")
      end
      data.merge("date" => date)
    end
    refute_empty posts
    assert_equal posts.map { |post| Time.iso8601(post["date"]) }.sort,
                 posts.map { |post| post["date"] }.sort.map { |date| Time.iso8601(date) }
  end

  def test_filename_derived_archive_date_keeps_its_original_utc_day
    path = File.join(ROOT, "_posts/2018/01/2018-01-31-aladdin-is-here.md")
    data = YAML.safe_load(File.read(path).split(/^---\s*$\n?/, 3)[1], permitted_classes: [Date, Time])
    # This post originally omitted date. Netlify/Jekyll used midnight UTC from
    # its filename; migrating local midnight would incorrectly show January 30.
    assert_equal Time.utc(2018, 1, 31), Time.iso8601(data.fetch("date"))
  end
end
