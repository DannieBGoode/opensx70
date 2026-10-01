require "test_helper"
require File.join(ROOT, "_plugins/image_dimensions")

class ImageDimensionsTest < Minitest::Test
  def write_image(bytes)
    @tmp ||= Dir.mktmpdir("opensx70-dimensions")
    file = File.join(@tmp, "image-#{bytes.hash}")
    File.binwrite(file, bytes)
    file
  end

  def teardown
    FileUtils.remove_entry(@tmp) if @tmp
  end

  # A minimal JPEG header: optional EXIF orientation, then a 200x100 SOF0 frame.
  def jpeg(orientation: nil, byte_order: "MM")
    bytes = "\xFF\xD8".b
    if orientation
      short, long = byte_order == "II" ? %w[v V] : %w[n N]
      tiff = byte_order.b + [0x2A].pack(short) + [8].pack(long) + [1].pack(short) + [0x0112, 3, 1, orientation, 0].pack("#{short}#{short}#{long}#{short}#{short}") + [0].pack(long)
      exif = "Exif\x00\x00".b + tiff
      bytes += "\xFF\xE1".b + [exif.bytesize + 2].pack("n") + exif
    end
    frame = [8, 100, 200, 3].pack("CnnC") + ("\x01\x11\x00".b * 3)
    bytes + "\xFF\xC0".b + [frame.bytesize + 2].pack("n") + frame + "\xFF\xD9".b
  end

  # Value: protects=srcset never claims widths a JPEG does not have; fails_when=the SOF scan misreads or skips the frame header; why_new=new reader; seam=none
  def test_reads_jpeg_width_from_the_frame_header
    assert_equal 200, OpenSX70ImageDimensions.width(write_image(jpeg))
    assert_equal 150, OpenSX70ImageDimensions.width(File.join(ROOT, "img/joaquin.jpg"))
  end

  # Value: protects=portrait phone photos stored sideways; fails_when=EXIF orientation is ignored and the stored (pre-rotation) width caps the srcset, so the displayed width is wrong; why_new=new reader; seam=none
  def test_rotated_jpegs_report_their_displayed_width
    assert_equal 100, OpenSX70ImageDimensions.width(write_image(jpeg(orientation: 6)))
    assert_equal 200, OpenSX70ImageDimensions.width(write_image(jpeg(orientation: 1)))
  end

  # Value: protects=rotated photos from cameras that write little-endian ("II") EXIF; fails_when=the II branch reads with big-endian unpack codes (or is dropped) and a sideways portrait reports its stored width; why_new=the rotation test only builds big-endian ("MM") EXIF; seam=none
  def test_little_endian_exif_orientation_is_honoured
    assert_equal 100, OpenSX70ImageDimensions.width(write_image(jpeg(orientation: 6, byte_order: "II")))
    assert_equal 200, OpenSX70ImageDimensions.width(write_image(jpeg(orientation: 1, byte_order: "II")))
  end

  # Value: protects=PNG sources; fails_when=the IHDR width offset is wrong; why_new=new reader; seam=none
  def test_reads_png_width
    png = "\x89PNG\r\n\x1A\n".b + [13].pack("N") + "IHDR" + [640, 480].pack("NN")

    assert_equal 640, OpenSX70ImageDimensions.width(write_image(png))
  end

  # Value: protects=the build when an image is missing or not a JPEG/PNG; fails_when=the reader raises instead of returning nil (callers then keep the full srcset); why_new=new reader; seam=none
  def test_unknown_files_have_no_width
    assert_nil OpenSX70ImageDimensions.width(File.join(ROOT, "img/does-not-exist.jpg"))
    assert_nil OpenSX70ImageDimensions.width(write_image("GIF89a"))
  end

  # Value: protects=the 1,414 progressive JPEGs and files with a Huffman table before the frame; fails_when=SOF2 is dropped from the frame markers or DHT (0xC4) is read as a frame, capping srcsets at a garbage width; why_new=fixtures only covered baseline SOF0; seam=none
  def test_progressive_jpegs_and_tables_before_the_frame
    frame = [8, 100, 200, 3].pack("CnnC") + ("\x01\x11\x00".b * 3)
    dht = "\xFF\xC4".b + [6].pack("n") + "\x00\x01\x02\x03".b
    progressive = "\xFF\xD8".b + dht + "\xFF\xC2".b + [frame.bytesize + 2].pack("n") + frame + "\xFF\xD9".b

    assert_equal 200, OpenSX70ImageDimensions.width(write_image(progressive))
    assert_nil OpenSX70ImageDimensions.width(write_image("\xFF\xD8".b))
  end

  # Value: protects=cover-cropped hints know each photo's shape; fails_when=size swaps width/height or ignores EXIF rotation for the height; why_new=size is new; seam=none
  def test_size_reports_displayed_width_and_height
    assert_equal [200, 100], OpenSX70ImageDimensions.size(write_image(jpeg))
    assert_equal [100, 200], OpenSX70ImageDimensions.size(write_image(jpeg(orientation: 6)))
  end

  # Value: protects=srcset caps on corrupt or unusual files; fails_when=a zero dimension or a PNG without IHDR is trusted and the build emits width="0" and a 0w candidate; why_new=adversarial review; seam=none
  def test_zero_or_malformed_dimensions_are_unknown
    zero = "\xFF\xD8".b + "\xFF\xC0".b + [8].pack("n") + [8, 0, 200, 0].pack("CnnC") + "\xFF\xD9".b
    no_ihdr = "\x89PNG\r\n\x1A\n".b + [13].pack("N") + "tEXt" + [640, 480].pack("NN")

    assert_nil OpenSX70ImageDimensions.size(write_image(zero))
    assert_nil OpenSX70ImageDimensions.size(write_image(no_ihdr))
  end

  # Value: protects=rotated photos whose EXIF block follows the frame header (non-conforming writers); fails_when=the reader stops at the frame and reports the stored width, halving the cap for a portrait; why_new=Codex adversarial review; seam=none
  def test_exif_after_the_frame_still_rotates
    frame = [8, 100, 200, 3].pack("CnnC") + ("\x01\x11\x00".b * 3)
    tiff = "MM\x00\x2A".b + [8].pack("N") + [1].pack("n") + [0x0112, 3, 1, 6, 0].pack("nnNnn") + [0].pack("N")
    exif = "Exif\x00\x00".b + tiff
    bytes = "\xFF\xD8".b + "\xFF\xC0".b + [frame.bytesize + 2].pack("n") + frame +
            "\xFF\xE1".b + [exif.bytesize + 2].pack("n") + exif + "\xFF\xDA".b

    assert_equal [100, 200], OpenSX70ImageDimensions.size(write_image(bytes))
  end

  # Value: protects=PNGs carrying an eXIf orientation; fails_when=PNG orientation is ignored and a rotated screenshot reports its stored width; why_new=Codex adversarial review; seam=none
  def test_png_exif_orientation_is_honoured
    ihdr = [640, 480, 8, 2, 0, 0, 0].pack("NNCCCCC")
    tiff = "MM\x00\x2A".b + [8].pack("N") + [1].pack("n") + [0x0112, 3, 1, 6, 0].pack("nnNnn") + [0].pack("N")
    png = "\x89PNG\r\n\x1A\n".b + [13].pack("N") + "IHDR" + ihdr + "\x00" * 4 +
          [tiff.bytesize].pack("N") + "eXIf" + tiff + "\x00" * 4 + [0].pack("N") + "IDAT" + "\x00" * 4

    assert_equal [480, 640], OpenSX70ImageDimensions.size(write_image(png))
  end

  # Value: protects=the build against hostile PNG uploads; fails_when=the eXIf chunk length is trusted and a 49-byte file makes Ruby allocate ~2-4 GB (Netlify build OOM); why_new=final adversarial review; testing review showed the first version of this test stayed green without the fix; seam=none
  def test_huge_png_chunk_lengths_are_not_read
    ihdr = [640, 480, 8, 2, 0, 0, 0].pack("NNCCCCC")
    [0xFFFFFFF0, 0x7FFFFFF0].each do |length|
      png = "\x89PNG\r\n\x1A\n".b + [13].pack("N") + "IHDR" + ihdr + "\x00" * 4 + [length].pack("N") + "eXIf" + "MM"
      file = write_image(png)
      rss_before = rss_kb

      assert_equal [640, 480], OpenSX70ImageDimensions.size(file)
      # Resident memory is only checkable where `ps` runs (CI, macOS).
      assert_operator rss_kb - rss_before, :<, 200_000, "reading #{file} allocated hundreds of MB" if rss_before
    end
  end

  def rss_kb
    rss = `ps -o rss= -p #{Process.pid} 2>/dev/null`.to_i
    rss.positive? ? rss : nil
  rescue SystemCallError
    nil
  end


  # Value: protects=rotated PNGs whose eXIf IFD sits deep in a large chunk; fails_when=the eXIf read is truncated (e.g. capped at 64 KB) and orientation 6 is treated as unrotated, swapping the width cap; why_new=run-2 Codex adversarial review; seam=none
  def test_png_exif_far_into_the_chunk_still_rotates
    ihdr = [1600, 400, 8, 2, 0, 0, 0].pack("NNCCCCC")
    offset = 70_000
    tiff = "MM\x00\x2A".b + [offset].pack("N")
    tiff += "\x00".b * (offset - tiff.bytesize) + [1].pack("n") + [0x0112, 3, 1, 6, 0].pack("nnNnn") + [0].pack("N")
    png = "\x89PNG\r\n\x1A\n".b + [13].pack("N") + "IHDR" + ihdr + "\x00" * 4 +
          [tiff.bytesize].pack("N") + "eXIf" + tiff + "\x00" * 4 + [0].pack("N") + "IDAT" + "\x00" * 4

    assert_equal [400, 1600], OpenSX70ImageDimensions.size(write_image(png))
  end

  # Value: protects=the Netlify build against a corrupt JPEG upload; fails_when=the length >= 2 guard is dropped and a segment length of 0 or 1 calls io.read with a negative length, raising ArgumentError (not rescued) and aborting the whole site build; why_new=no fixture had a segment length below 2; seam=none
  def test_jpeg_segment_lengths_below_two_are_unknown_not_fatal
    [0, 1].each do |length|
      bytes = "\xFF\xD8".b + "\xFF\xE0".b + [length].pack("n") + "\x00" * 16 + "\xFF\xD9".b

      assert_nil OpenSX70ImageDimensions.size(write_image(bytes)), "segment length #{length}"
    end
  end

  # Value: protects=the Netlify build when a photo carries a corrupt EXIF block; fails_when=exif_orientation loses its unknown-byte-order, out-of-range-IFD or truncated-entry guards and raises TypeError/NoMethodError mid-build instead of keeping the frame size; why_new=EXIF fixtures were all well-formed; seam=none
  def test_malformed_exif_keeps_the_stored_size
    frame = [8, 100, 200, 3].pack("CnnC") + ("\x01\x11\x00".b * 3)
    malformed = {
      "unknown byte order" => "XX\x00\x2A".b + [8].pack("N") + [1].pack("n"),
      "IFD offset past the block" => "MM\x00\x2A".b + [4096].pack("N"),
      "truncated orientation entry" => "MM\x00\x2A".b + [8].pack("N") + [1].pack("n") + [0x0112, 3].pack("nn"),
    }

    malformed.each do |label, tiff|
      exif = "Exif\x00\x00".b + tiff
      bytes = "\xFF\xD8".b + "\xFF\xE1".b + [exif.bytesize + 2].pack("n") + exif +
              "\xFF\xC0".b + [frame.bytesize + 2].pack("n") + frame + "\xFF\xD9".b

      assert_equal [200, 100], OpenSX70ImageDimensions.size(write_image(bytes)), label
    end
  end

  # Value: protects=photos re-saved with two EXIF blocks; fails_when=the last block wins (browsers use the first) and width/height swap when the blocks disagree; why_new=run-2 adversarial review; seam=none
  def test_the_first_exif_block_wins
    frame = [8, 100, 200, 3].pack("CnnC") + ("\x01\x11\x00".b * 3)
    exif = lambda do |orientation|
      tiff = "MM\x00\x2A".b + [8].pack("N") + [1].pack("n") + [0x0112, 3, 1, orientation, 0].pack("nnNnn") + [0].pack("N")
      body = "Exif\x00\x00".b + tiff
      "\xFF\xE1".b + [body.bytesize + 2].pack("n") + body
    end
    bytes = "\xFF\xD8".b + exif.call(6) + exif.call(1) + "\xFF\xC0".b + [frame.bytesize + 2].pack("n") + frame + "\xFF\xD9".b

    assert_equal [100, 200], OpenSX70ImageDimensions.size(write_image(bytes))
  end
end
