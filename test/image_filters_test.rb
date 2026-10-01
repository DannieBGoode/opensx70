require "test_helper"
require File.join(ROOT, "_plugins/image_filters")

class ImageFiltersTest < Minitest::Test
  include OpenSX70ImageFilters

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
end
