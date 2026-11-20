require "test_helper"

class ExternalImagesTest < Minitest::Test
  # Value: protects=valid markup in posts that embed external photos; fails_when=the content preset leaves sizes on images without a srcset; why_new=red-team found 16 in the build; seam=none
  def test_external_images_carry_no_orphan_sizes
    html = File.read(File.join(built_site, "a-look-inside-the-chips-on-the-sx-70-camera-t-i.html"))
    orphans = html.scan(/<img\b[^>]*>/).select { |tag| tag.match?(/\ssizes=/) && !tag.match?(/\ssrcset=/) }

    refute_empty html.scan(/<img [^>]*static\.righto\.com/), "fixture post should still embed external images"
    assert_empty orphans
  end
end
