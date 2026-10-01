require "test_helper"
require File.join(ROOT, "_plugins/image_filters")

class ImageFiltersTest < Minitest::Test
  include OpenSX70ImageFilters

  # natural_width reads files relative to the site source; do not depend on Dir.pwd.
  def setup
    OpenSX70ImageFilters.source_dir = ROOT
  end

  def teardown
    FileUtils.remove_entry(@tmp) if @tmp && File.exist?(@tmp)
  end

  # Value: protects=first image stays eager (LCP) while later images and all embeds defer; fails_when=iframes are skipped or count as the eager first image; why_new=no unit test covered lazy_images; seam=none
  def test_lazy_images_defers_embeds_and_later_images
    input = %(<iframe src="https://www.youtube.com/embed/x"></iframe><img src="/a.jpg"><img src="/b.jpg">)
    expected = %(<iframe src="https://www.youtube.com/embed/x" loading="lazy"></iframe><img src="/a.jpg"><img src="/b.jpg" loading="lazy" decoding="async">)

    assert_equal expected, lazy_images(input)
  end

  # Value: protects=listing previews after the first post load nothing eagerly; fails_when=`eager_first: false` is ignored and every preview's first image loads eagerly; why_new=homepage/listing tests check rendered pages, not the filter contract; seam=none
  def test_lazy_images_can_defer_the_first_image
    assert_equal %(<img src="/a.jpg" loading="lazy" decoding="async">), lazy_images(%(<img src="/a.jpg">), false)
  end

  # Value: protects=lazy loading never alters the image itself; fails_when=src or srcset are rewritten while adding loading attributes; why_new=no test pins that only loading/decoding are added; seam=none
  def test_lazy_images_leaves_sources_untouched
    tag = %(<img src="/a.jpg" srcset="/a.jpg 800w" sizes="100vw">)

    assert_equal tag.sub(">", ' loading="lazy" decoding="async">'), lazy_images(tag, false)
  end

  def with_cdn
    previous = ENV["OPENSX70_USE_NETLIFY_IMAGE_CDN"]
    ENV["OPENSX70_USE_NETLIFY_IMAGE_CDN"] = "true"
    yield
  ensure
    ENV["OPENSX70_USE_NETLIFY_IMAGE_CDN"] = previous
  end

  def widths(markup)
    markup[/<source [^>]*srcset="([^"]*)"/, 1].to_s.scan(/ (\d+)w/).flatten.map(&:to_i)
  end

  # Value: protects=variants close to each display size (PageSpeed "properly size images"); fails_when=the ladder drops back to 320/800/1600 and a 513px slot downloads the 800w file; why_new=no test pinned the ladder; seam=none
  def test_large_images_offer_intermediate_widths
    with_cdn do
      assert_equal [320, 400, 480, 560, 640, 800, 960, 1200, 1600, 2400, 3200, 3848],
                   widths(OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2025/zane.jpg">)))
    end
  end

  # Value: protects=small photos render at their own size, as the original file did; fails_when=srcset claims widths larger than the source (the CDN does not upscale), so browsers compute the wrong density and shrink the photo; why_new=no test covered sources narrower than the ladder; seam=none
  def test_srcset_stops_at_the_source_width
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2024/mom-in-fur-coat.jpg">))

      assert_equal [320, 400, 480, 518], widths(markup)
      assert_includes markup, %(width="518")
    end
  end

  # Value: protects=author-set image widths; fails_when=the natural width overwrites a width the post already chose; why_new=new width attribute; seam=none
  def test_existing_width_attribute_is_kept
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2024/mom-in-fur-coat.jpg" width="200">))

      assert_equal 1, markup.scan(/\bwidth=/).size
      assert_includes markup, %(width="200")
    end
  end

  # Value: protects=layouts can declare how wide their images display; fails_when=image_sizes is ignored or its sizes stay on the fallback <img> (invalid without srcset); why_new=new filter; seam=none
  def test_image_sizes_sets_the_preset_on_the_webp_source
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(image_sizes(%(<img src="/img/2025/zane.jpg">), "content"))

      assert_includes markup, %(<source type="image/webp" srcset=)
      assert_includes markup, %(sizes="#{OpenSX70ImageFilters::SIZES_PRESETS.fetch("content")}">)
      assert_equal 1, markup.scan(/\bsizes=/).size
    end
  end

  # Value: protects=local development output; fails_when=image_sizes adds sizes without the srcset that only the CDN build provides; why_new=new filter; seam=none
  def test_image_sizes_is_a_no_op_without_the_cdn
    previous = ENV.delete("OPENSX70_USE_NETLIFY_IMAGE_CDN")
    assert_equal %(<img src="/img/a.jpg">), image_sizes(%(<img src="/img/a.jpg">), "content")
  ensure
    ENV["OPENSX70_USE_NETLIFY_IMAGE_CDN"] = previous
  end

  # Value: protects=typos in layouts; fails_when=an unknown preset silently falls back to the default hint; why_new=new filter; seam=none
  def test_unknown_image_sizes_preset_fails_the_build
    with_cdn { assert_raises(KeyError) { image_sizes(%(<img src="/img/a.jpg">), "nope") } }
  end

  # Value: protects=avatar bandwidth (PageSpeed flagged a 576x720 guest.jpg shown at 50px); fails_when=user-icon images skip the CDN again; why_new=avatars were excluded; seam=none
  def test_avatars_use_cdn_variants_no_wider_than_the_source
    with_cdn do
      assert_equal [150], widths(OpenSX70ImageFilters.responsive_markup(%(<img src="/img/joaquin.jpg" class="user-icon">)))
      assert_equal [320, 400, 480, 560, 576], widths(OpenSX70ImageFilters.responsive_markup(%(<img src="/img/guest.jpg" class="user-icon">)))
    end
  end

  # Value: protects=filenames with spaces, which posts link URL-encoded; fails_when=natural_width stops decoding %20 and those photos fall back to the full ladder (claiming 3200w for an 800px file); also pins that a source exactly on a ladder step is listed once; why_new=only unencoded paths were tested; seam=none
  def test_url_encoded_sources_are_capped_at_their_width
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2019/10/SX70-focuswheel-bottom%20-%20mirror.jpg">))

      assert_equal [320, 400, 480, 560, 640, 800], widths(markup)
      assert_includes markup, %(width="800")
    end
  end

  # Value: protects=images whose size cannot be read keep working markup; fails_when=a missing/unreadable source drops its srcset or gets a bogus width attribute; why_new=the dimensions test checks the reader returns nil, not what the filter does with nil; seam=none
  def test_unreadable_sources_keep_the_full_ladder_without_a_width
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/does-not-exist.jpg">))

      assert_equal OpenSX70ImageFilters::RESPONSIVE_WIDTHS, widths(markup)
      refute_match(/\swidth=/, markup)
    end
  end

  # Value: protects=the Netlify build when a post links a file whose name contains a bare "%" (e.g. "100%.jpg"); fails_when=natural_width's URL-decode fallback raises ArgumentError on invalid %-encoding and aborts the whole site build; why_new=no test used a non-decodable src; seam=none
  def test_sources_with_a_bare_percent_do_not_break_the_build
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2024/100%.jpg">))

      assert_equal OpenSX70ImageFilters::RESPONSIVE_WIDTHS, widths(markup)
    end
  end

  # Value: protects=the product gallery's thumbnail swap (data-image-srcset in product.html); fails_when=netlify_image_srcset keeps the uncapped ladder while <img> markup is capped, so swapping thumbnails claims 3200w for a 518px file and the photo renders shrunk; why_new=only responsive_markup was tested; seam=none
  def test_gallery_srcset_stops_at_the_source_width
    with_cdn do
      srcset = netlify_image_srcset("/img/2024/mom-in-fur-coat.jpg")

      assert_equal [320, 400, 480, 518], srcset.scan(/ (\d+)w/).flatten.map(&:to_i)
    end
  end

  # Value: protects=the product gallery's full-resolution variant after a thumbnail swap; fails_when=netlify_image_srcset (a separate code path from responsive_tag) passes the source width as `w` again, asking the CDN to resize a 5519px photo to itself; why_new=the no-resize test only covers responsive_markup; seam=none
  def test_gallery_full_width_candidate_is_not_resized
    with_cdn do
      srcset = netlify_image_srcset("/img/2025/band.jpg")

      assert_includes srcset, "/.netlify/images?url=/img/2025/band.jpg&fm=webp&q=95 5519w"
      refute_includes srcset, "w=5519"
    end
  end

  # Value: protects=tutorial/category card sharpness; fails_when=the hint drops back to 320px on desktop while cards display up to 591px (blurry 320w pick); why_new=sizes_for category-image had no test; seam=none
  def test_category_cards_hint_their_full_column_width
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img class="category-image" src="/img/2025/zane.jpg">))

      assert_includes markup, %(sizes="#{OpenSX70ImageFilters::MAIN_COLUMN_SIZES}")
    end
  end

  # Value: protects=author bio avatars (150/220px) stay sharp while 50-60px list avatars download a small variant; fails_when=the author-avatar or user-icon hints merge again (bio blurry, or every list avatar oversized); why_new=sizes_for avatar branches had no assertion; seam=none
  def test_avatar_hints_match_where_they_display
    with_cdn do
      bio = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/guest.jpg" class="user-icon author-avatar">))
      list = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/guest.jpg" class="user-icon user-1">))

      assert_includes bio, %(sizes="(min-width: 992px) 220px, 150px")
      assert_includes list, %(sizes="60px")
    end
  end

  # Value: protects=hand-written responsive markup in posts; fails_when=image_sizes overwrites or duplicates a sizes/srcset the author already set; why_new=add_sizes skip branch untested; seam=none
  def test_image_sizes_leaves_existing_responsive_markup_alone
    with_cdn do
      [%(<img src="/img/a.jpg" sizes="50vw">), %(<img src="/img/a.jpg" srcset="/img/a.jpg 800w">)].each do |tag|
        assert_equal tag, image_sizes(tag, "content")
      end
    end
  end

  # Value: protects=PNG screenshots in posts get the layout's hint once; fails_when=the PNG branch appends a second sizes attribute next to the preset (browsers use the first, and markup is invalid); why_new=preset tests only cover the WebP <picture> branch; seam=none
  def test_png_images_keep_a_single_preset_sizes
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(image_sizes(%(<img src="/img/tutorials/image20.png">), "content"))

      assert_includes markup, "srcset="
      assert_equal [%(sizes="#{CGI.escapeHTML(OpenSX70ImageFilters::SIZES_PRESETS.fetch("content"))}")], markup.scan(/\bsizes="[^"]*"/)
    end
  end

  # Value: protects=valid markup for images the CDN skips; fails_when=image_sizes adds sizes to external or SVG images that never get a srcset; why_new=red-team found 16 such tags in the build; seam=none
  def test_image_sizes_skips_images_without_cdn_variants
    with_cdn do
      [%(<img src="https://static.righto.com/a.jpg">), %(<img src="/img/shop/a.svg">)].each do |tag|
        assert_equal tag, image_sizes(tag, "content")
      end
    end
  end

  # Value: protects=class-specific hints (shop cards, category cards) inside page content; fails_when=the page preset overrides them and /shop cards download 750px variants for 360px cards; why_new=red-team found the override on /shop; seam=none
  def test_class_specific_hints_win_over_the_layout_preset
    with_cdn do
      tag = %(<img class="shop-card-image" src="/img/2025/zane.jpg">)

      assert_equal tag, image_sizes(tag, "content")
    end
  end

  # Value: protects=generated attributes stay inert; fails_when=a single-quoted sizes containing a double quote is re-emitted unescaped and injects attributes (e.g. onerror); why_new=security review; seam=none
  def test_reused_sizes_values_are_escaped
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/tutorials/image20.png" sizes='1px" onerror="x'>))

      refute_match(/onerror="x"/, markup)
      assert_includes markup, %(sizes="1px&quot; onerror=&quot;x")
    end
  end

  # Value: protects=the build never reads files outside the site source; fails_when=natural_width follows "../" out of the source tree and leaks a file's width into public HTML; why_new=security review; seam=none
  def test_paths_outside_the_source_have_no_width
    outside = File.join(@tmp = Dir.mktmpdir("opensx70-outside"), "secret.png")
    File.binwrite(outside, "\x89PNG\r\n\x1A\n".b + [13].pack("N") + "IHDR" + [640, 480].pack("NN"))
    relative = "/img/" + ("../" * 20) + outside.delete_prefix("/")

    assert File.file?(File.join(ROOT, relative)), "fixture path should resolve outside the repo"
    assert_nil OpenSX70ImageFilters.natural_width(relative)
  end

  # Value: protects=srcset caps follow the site being built; fails_when=the :after_init hook is removed and builds with --source elsewhere silently fall back to Dir.pwd; why_new=Dir.pwd == ROOT hid the hook in every other test; seam=none
  def test_site_initialisation_sets_the_source_dir
    previous = OpenSX70ImageFilters.source_dir
    OpenSX70ImageFilters.source_dir = "/nonexistent"
    Jekyll::Site.new(Jekyll.configuration("source" => ROOT, "destination" => (@tmp = Dir.mktmpdir), "quiet" => true))

    assert_equal ROOT, OpenSX70ImageFilters.source_dir
  ensure
    OpenSX70ImageFilters.source_dir = previous
  end

  # Value: protects=sharpness of cover-cropped thumbnails; fails_when=landscape photos in square cover boxes keep the box-width hint (a 2.6:1 photo displays 2.6x wider than its card) or portrait ones get inflated; why_new=pass-2 performance review measured 0.45 source px per CSS px; seam=none
  def test_cover_boxes_widen_the_hint_for_cropped_photos
    assert_equal "(min-width: 768px) 125vw, 250vw",
                 OpenSX70ImageFilters.cover_sizes("(min-width: 768px) 50vw, 100vw", :square, [2500, 1000])
    assert_equal "60px", OpenSX70ImageFilters.cover_sizes("60px", :square, [576, 720])
    assert_equal "(min-width: 992px) 168px, max(calc(28vw - 25px), 168px)",
                 OpenSX70ImageFilters.cover_sizes("(min-width: 992px) 145px, calc(28vw - 25px)", 84, [2000, 1000])
  end

  # Value: protects=layout typos are caught in local builds too; fails_when=image_sizes only looks the preset up when the CDN is on, so a typo passes locally and breaks Netlify; why_new=pass-2 maintainability review; seam=none
  def test_unknown_preset_fails_without_the_cdn
    previous = ENV.delete("OPENSX70_USE_NETLIFY_IMAGE_CDN")
    assert_raises(KeyError) { image_sizes(%(<img src="/img/a.jpg">), "nope") }
  ensure
    ENV["OPENSX70_USE_NETLIFY_IMAGE_CDN"] = previous
  end

  # Value: protects=`jekyll serve` picks up images replaced in place; fails_when=the :after_reset hook stops clearing the dimension cache and rebuilds keep a stale width cap; why_new=pass-2 testing review; seam=none
  def test_site_reset_rereads_replaced_images
    file = File.join(@tmp = Dir.mktmpdir("opensx70-reset"), "a.png")
    png = ->(width) { "\x89PNG\r\n\x1A\n".b + [13].pack("N") + "IHDR" + [width, 10].pack("NN") }
    File.binwrite(file, png.call(640))
    assert_equal 640, OpenSX70ImageDimensions.width(file)

    File.binwrite(file, png.call(1280))
    Jekyll::Site.new(Jekyll.configuration("source" => ROOT, "destination" => @tmp, "quiet" => true))

    assert_equal 1280, OpenSX70ImageDimensions.width(file)
  ensure
    OpenSX70ImageFilters.source_dir = ROOT
  end

  # Value: protects=photos sized by height in raw HTML keep their shape; fails_when=the natural width is added next to an explicit height (518x640 photo with height=100 forced to 518x100); why_new=adversarial review (Claude + Codex); seam=none
  def test_height_only_images_get_no_width
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2024/mom-in-fur-coat.jpg" height="100">))

      refute_match(/\swidth=/, markup)
      assert_includes markup, "srcset="
    end
  end

  # Value: protects=sources wider than the ladder keep all their detail; fails_when=srcset stops at 3200w and a 5519px photo in a large cover-cropped card at 2x upscales; why_new=Codex adversarial review; seam=none
  def test_sources_wider_than_the_ladder_offer_their_full_width
    with_cdn do
      assert_equal 5519, widths(OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2025/band.jpg">))).last
    end
  end

  # Value: protects=lazy-loader markup; fails_when=data-src/data-srcset images are wrapped in <picture> (loading eagerly, ignoring the loader) or data-src is rewritten instead of src; why_new=adversarial review; seam=none
  def test_lazy_loader_markup_is_left_alone
    with_cdn do
      tag = %(<img data-src="/img/2025/zane.jpg" src="/img/2024/mom-in-fur-coat.jpg">)

      assert_equal tag, OpenSX70ImageFilters.responsive_markup(tag)
      assert_equal tag, image_sizes(tag, "content")
    end
  end

  # Value: protects=a lone product card that stretches across the auto-fit grid; fails_when=the solo card keeps the 370px multi-column hint (a ~747px card on desktop); why_new=Codex adversarial review; seam=none
  def test_a_lone_shop_card_hints_the_full_content_width
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img class="shop-card-image shop-card-image-solo" src="/img/shop/img_1044.jpeg">))

      assert_includes markup, %(sizes="(min-width: 1200px) 750px, (min-width: 992px) 700px, (min-width: 768px) 640px, max(85vw, 235px)")
    end
  end

  # Value: protects=the full-resolution variant always loads; fails_when=the last candidate asks the CDN to resize to the source width itself (e.g. w=5519), which may exceed the CDN's resize limit and break the image; why_new=final adversarial review; seam=none
  def test_the_full_width_candidate_is_not_resized
    with_cdn do
      srcset = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2025/band.jpg">))[/<source [^>]*srcset="([^"]*)"/, 1]

      assert_includes srcset, "/.netlify/images?url=/img/2025/band.jpg&amp;fm=webp&amp;q=95 5519w"
      refute_includes srcset, "w=5519"
    end
  end

  # Value: protects=the build never reads files outside the site source; fails_when=a symlink inside img/ points outside the repo and its width leaks into public HTML; why_new=final adversarial review; seam=none
  def test_symlinks_out_of_the_source_have_no_width
    outside = File.join(@tmp = Dir.mktmpdir("opensx70-symlink"), "secret.png")
    File.binwrite(outside, "\x89PNG\r\n\x1A\n".b + [13].pack("N") + "IHDR" + [640, 480].pack("NN"))
    root = File.join(@tmp, "site")
    FileUtils.mkdir_p(File.join(root, "img"))
    File.symlink(outside, File.join(root, "img", "leak.png"))
    OpenSX70ImageFilters.source_dir = root

    assert_nil OpenSX70ImageFilters.natural_width("/img/leak.png")
  end

  # Value: protects=photos sized by an inline CSS height keep their shape; fails_when=the natural width is added next to style="height:100px" (518x640 photo forced to 518x100); why_new=run-2 adversarial review (Claude + Codex); seam=none
  def test_inline_style_sizing_gets_no_width
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2024/mom-in-fur-coat.jpg" style="height:100px">))

      refute_match(/\swidth="/, markup)
    end
  end

  # Value: protects=hint accuracy when markup carries an empty sizes; fails_when=sizes="" is reused (browsers read it as 100vw) instead of the class hint; why_new=run-2 adversarial review; seam=none
  def test_empty_sizes_fall_back_to_the_class_hint
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img class="user-icon" src="/img/guest.jpg" sizes="">))

      assert_equal [%(sizes="60px")], markup.scan(/\ssizes="[^"]*"/).map(&:strip)
    end
  end

  # Value: protects=bytes on very large sources; fails_when=the ladder jumps from 3200w straight to the unresized original (a 3271px slot loads the full 5519px band.jpg); why_new=run-2 performance review; seam=none
  def test_sources_above_3200_get_intermediate_steps
    with_cdn do
      assert_equal [3200, 4000, 4800, 5519], widths(OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2025/band.jpg">))).last(4)
    end
  end

  # Value: protects=small photos with layout-neutral inline styles keep their own size; fails_when=max-width/min-width/border-width/line-height count as sizing and the natural width is dropped (a 518px photo stretched to the 750px slot); why_new=run-2 pass-2 review (all reviewers); seam=none
  def test_layout_neutral_styles_keep_the_natural_width
    with_cdn do
      ["max-width:100%", "min-width: 10px", "border-width:0", "line-height:1"].each do |style|
        markup = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2024/mom-in-fur-coat.jpg" style="#{style}">))

        assert_includes markup, %(width="518"), style
      end
      refute_match(/\swidth="518"/, OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2024/mom-in-fur-coat.jpg" style="border:0; height: 80px">)))
    end
  end

  # Value: protects=alt/title text cannot switch off sizing; fails_when=alt="board width = 5cm" is read as a width attribute and the natural width is dropped; why_new=run-2 adversarial review; seam=none
  def test_attribute_like_alt_text_is_not_an_attribute
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img alt="board width = 5cm" src="/img/2024/mom-in-fur-coat.jpg">))

      assert_includes markup, %(width="518")
    end
  end

  # Value: protects=content images written with sizes="" still get the layout hint; fails_when=an empty sizes blocks the preset and the image falls back to the 1200px default; why_new=run-2 pass-2 testing review; seam=none
  def test_empty_sizes_take_the_layout_preset
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(image_sizes(%(<img src="/img/2025/zane.jpg" sizes="">), "content"))

      assert_equal [%(sizes="#{CGI.escapeHTML(OpenSX70ImageFilters::SIZES_PRESETS.fetch("content"))}")], markup.scan(/\ssizes="[^"]*"/).map(&:strip)
    end
  end

  # Value: protects=markup for PNG paths containing backslashes; fails_when=String#sub treats "\\0" in the path as a back-reference and duplicates the src into the tag; why_new=run-2 adversarial review; seam=none
  def test_png_paths_with_backslashes_are_not_corrupted
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(%(<img src="/img/a\\0b.png">))

      assert_equal 1, markup.scan("src=").size
      assert_includes markup, %(src="/img/a\\0b.png" srcset=)
    end
  end

  # Value: protects=the build against malformed image URLs; fails_when=a NUL byte (%00 or &#0;) or an invalid character reference reaches File APIs and aborts the whole Jekyll build; why_new=run-2 pass-3 review (Claude + Codex); seam=none
  def test_malformed_image_urls_do_not_break_the_build
    with_cdn do
      ["/img/a%00.jpg", "/img/a&#0;.jpg", "/img/a&#xD800;.jpg"].each do |src|
        markup = OpenSX70ImageFilters.responsive_markup(%(<img src="#{src}">))

        assert_includes markup, "<img", src
      end
    end
  end

  # Value: protects=build time against long whitespace runs in CMS markup; fails_when=attribute matching backtracks quadratically (80k spaces took 33s with the old sizes regex); why_new=run-2 pass-3 adversarial review; seam=none
  def test_long_whitespace_runs_stay_fast
    with_cdn do
      tag = %(<img src="/img/2025/zane.jpg"#{" \t" * 40_000} sizes="1px"#{" " * 40_000}>)
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      OpenSX70ImageFilters.responsive_markup(image_sizes(tag, "content"))

      assert_operator Process.clock_gettime(Process::CLOCK_MONOTONIC) - started, :<, 2
    end
  end

  # Value: protects=photos whose alt text mentions a class or sizes; fails_when=class hints are matched against the whole tag, so alt="class='user-icon'" gives a full-width photo a 60px hint (blurry 320w download); why_new=run-2 pass-3 Codex review; seam=none
  def test_class_and_sizes_text_inside_alt_is_ignored
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(image_sizes(%(<img alt="class='user-icon' sizes='1px'" src="/img/2025/zane.jpg">), "content"))

      assert_includes markup, %(sizes="#{CGI.escapeHTML(OpenSX70ImageFilters::SIZES_PRESETS.fetch("content"))}")
      assert_includes markup, %(alt="class='user-icon' sizes='1px'")
    end
  end

  # Value: protects=photos sized by inline CSS written with comments or character references; fails_when=style="/* note */height:300px" or "height&#58;300px" is missed and the natural width stretches the photo; why_new=run-2 pass-3 Codex review; seam=none
  def test_obfuscated_inline_heights_still_count_as_sizing
    with_cdn do
      ["/* note */height:300px", "height&#58;300px"].each do |style|
        refute_match(/\swidth="/, OpenSX70ImageFilters.responsive_markup(%(<img src="/img/2024/mom-in-fur-coat.jpg" style="#{style}">)), style)
      end
    end
  end

  # Value: protects=valid markup for unquoted src values; fails_when=image_sizes and responsive_tag disagree on unquoted src and leave a sizes without srcset; why_new=run-2 pass-3 maintainability review; seam=none
  def test_unquoted_sources_are_handled_consistently
    with_cdn do
      markup = OpenSX70ImageFilters.responsive_markup(image_sizes(%(<img src=/img/2025/zane.jpg alt="x">), "content"))

      assert_includes markup, %(<source type="image/webp" srcset=)
      assert_includes markup, %(src="/.netlify/images?url=/img/2025/zane.jpg&amp;w=2400&amp;fm=jpg&amp;q=95")
    end
  end

  # Value: protects=markup the tokenizer cannot parse is left exactly as written; fails_when=a stray quote makes the rewrite drop or reorder text; why_new=attribute tokenizer is new; seam=none
  def test_unparseable_tags_are_left_untouched
    with_cdn do
      tag = %(<img src="/img/2025/zane.jpg" "stray">)

      assert_equal tag, OpenSX70ImageFilters.responsive_markup(tag)
    end
  end

  # Value: protects=build logs flag images whose size cannot be read, once each; fails_when=the warning is dropped (silent degradation) or repeats for every call and page; why_new=run-2 pass-3 testing review; seam=none
  def test_unknown_sizes_warn_once_per_image
    messages = []
    logger = Jekyll.logger
    logger.define_singleton_method(:warn) { |*args| messages << args.join(" ") }
    2.times { OpenSX70ImageFilters.natural_size("/img/never-there-#{object_id}.jpg") }
    OpenSX70ImageFilters.natural_size("/img/2025/zane.jpg")

    assert_equal 1, messages.size
    assert_includes messages.first, "never-there-#{object_id}.jpg"
  ensure
    logger.singleton_class.send(:remove_method, :warn) if logger&.singleton_methods&.include?(:warn)
  end

  # Value: protects=cover hints parse in every browser and never shrink; fails_when=hints emit nested calc() or calc(length * number) (rejected by some older WebViews, which then fall back to 100vw), or rounding makes a scaled term smaller than the exact product; why_new=PR #15 review comment; seam=none
  def test_scaled_hints_use_plain_rounded_up_terms
    assert_equal "46.73vw", OpenSX70ImageFilters.scale_length("18vw", 2.596)
    assert_equal "calc(129.8vw + 51.92px)", OpenSX70ImageFilters.scale_length("calc(50vw + 20px)", 2.596)
    assert_equal "calc(235.2vw - 117.6px)", OpenSX70ImageFilters.scale_length("calc(84vw - 42px)", 2.8)
    assert_equal "150.6px", OpenSX70ImageFilters.scale_length("60px", 2.51)
    assert_equal "129.8vw", OpenSX70ImageFilters.scale_length("50vw", 2.596)

    markup = OpenSX70ImageFilters.cover_sizes("(min-width: 992px) 18vw, (min-width: 768px) calc(50vw + 20px), calc(100vw + 30px)", :square, [5519, 2126])
    refute_match(/calc\([^)]*calc\(|\*/, markup)
  end
end
