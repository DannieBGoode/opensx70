require "test_helper"
require File.join(ROOT, "_plugins/image_filters")

class ShopImagesTest < Minitest::Test
  # Value: protects=/shop card sharpness and weight (cards are 278-581px on mobile, 301-360px above); fails_when=the page "content" preset overrides the card hint again, or the hint drops back to 50vw/320px (blurry on phones); why_new=red-team found the override; no test covered /shop; seam=none
  def test_shop_cards_hint_their_grid_width
    html = File.read(File.join(built_site, "shop.html"))
    sources = html.scan(%r{<source [^>]*>(?=<img [^>]*shop-card-image)})

    refute_empty sources
    # Product photos are square; the 235px-tall cover box sets the phone minimum.
    sources.each { |tag| assert_includes tag, 'sizes="(min-width: 1200px) 370px, (min-width: 992px) 340px, (min-width: 768px) 310px, max(calc(84vw + 12px), 235px)"' }
  end

  # Value: protects=valid markup in posts that embed external photos; fails_when=the content preset leaves sizes on images without a srcset; why_new=red-team found 16 in the build; seam=none
  def test_external_images_carry_no_orphan_sizes
    html = File.read(File.join(built_site, "a-look-inside-the-chips-on-the-sx-70-camera-t-i.html"))
    orphans = html.scan(/<img\b[^>]*>/).select { |tag| tag.match?(/\ssizes=/) && !tag.match?(/\ssrcset=/) }

    refute_empty html.scan(/<img [^>]*static\.righto\.com/), "fixture post should still embed external images"
    assert_empty orphans
  end

  # Value: protects=product photo sharpness (thumbs show at up to 187px, the main image at up to 599px); fails_when=the thumb hint drops back to 96px (a 320w file for a 366-device-pixel tablet thumb) or the main hint undershoots; why_new=browser check found the 96px undershoot; seam=none
  def test_product_gallery_hints_cover_their_display_size
    html = File.read(File.join(built_site, "shop/ecm-main-pcb/index.html"))
    thumb = html[%r{<source [^>]*>(?=<img [^>]*product-thumb)}] || flunk("no responsive product thumbnail")
    main = html[%r{<source [^>]*>(?=<img [^>]*product-main-image)}] || flunk("no responsive main image")

    assert_includes thumb, 'sizes="(min-width: 992px) 145px, (min-width: 768px) 185px, max(calc(28vw - 25px), 84px)"'
    assert_includes main, 'sizes="(min-width: 992px) 465px, (min-width: 768px) 580px, calc(84vw - 45px)"'
  end
end
