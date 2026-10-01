# Reads the displayed pixel size of local JPEG and PNG files from their
# headers, so responsive markup never offers widths larger than the source.
# Honours EXIF orientation, as browsers and the image CDN do.
module OpenSX70ImageDimensions
  PNG_SIGNATURE = "\x89PNG\r\n\x1A\n".b
  JPEG_SIGNATURE = "\xFF\xD8".b
  # Start-of-frame markers carry the image size (C4, C8 and CC are not frames).
  SOF_MARKERS = [*0xC0..0xC3, *0xC5..0xC7, *0xC9..0xCB, *0xCD..0xCF].freeze
  # Orientations 5-8 store the image rotated by 90 degrees.
  ROTATED_ORIENTATIONS = [5, 6, 7, 8].freeze

  @cache = {}

  class << self
    # [width, height], or nil when the file is missing or not a JPEG/PNG.
    def size(file)
      @cache.fetch(file) { @cache[file] = read_size(file) }
    end

    def width(file)
      size(file)&.first
    end

    def reset!
      @cache.clear
    end

    private

    def read_size(file)
      File.open(file, "rb") do |io|
        header = io.read(24).to_s
        if header.start_with?(PNG_SIGNATURE)
          png_size(io, header)
        elsif header.start_with?(JPEG_SIGNATURE)
          io.seek(2)
          jpeg_size(io)
        end
      end
    rescue SystemCallError, IOError
      nil
    end

    def png_size(io, header)
      return nil unless header.bytesize == 24 && header.byteslice(12, 4) == "IHDR"

      width, height = header.byteslice(16, 8).unpack("NN")
      return nil unless width.positive? && height.positive?

      # eXIf may carry an orientation; it must precede the image data.
      io.seek(33)
      loop do
        length, type = io.read(8).to_s.unpack("Na4")
        break if length.nil? || type.nil? || type == "IDAT" || type == "IEND"

        if type == "eXIf"
          # Read only the bytes the orientation lookup needs, never the whole
          # chunk: a hostile length must not make the build allocate gigabytes.
          start = io.pos
          read_at = lambda do |offset, bytes|
            next "" if offset.negative? || offset >= length

            io.seek(start + offset)
            io.read([bytes, length - offset].min).to_s
          end
          rotated = ROTATED_ORIENTATIONS.include?(exif_orientation(read_at))
          return rotated ? [height, width] : [width, height]
        end
        io.seek(length + 4, IO::SEEK_CUR)
      end
      [width, height]
    end

    def jpeg_size(io)
      rotated = false
      exif_seen = false
      size = nil

      loop do
        marker = next_marker(io)
        # Image data starts (or the file ends): use the frame size found so far.
        if marker.nil? || marker == 0xD9 || marker == 0xDA
          return nil unless size

          return rotated ? size.reverse : size
        end
        # Markers without a length field.
        next if marker == 0x01 || (0xD0..0xD7).cover?(marker)

        length = io.read(2)&.unpack1("n")
        return nil unless length && length >= 2

        segment = io.read(length - 2).to_s
        # Like browsers, use the first EXIF block only.
        if marker == 0xE1 && segment.start_with?("Exif\x00\x00".b) && !exif_seen
          exif_seen = true
          tiff = segment.byteslice(6..)
          rotated = ROTATED_ORIENTATIONS.include?(exif_orientation(->(offset, bytes) { tiff.byteslice(offset, bytes).to_s }))
        elsif SOF_MARKERS.include?(marker) && size.nil?
          height, width = segment.byteslice(1, 4).to_s.unpack("nn")
          return nil unless width.to_i.positive? && height.to_i.positive?

          # Keep scanning: a (non-conforming) EXIF block may follow the frame.
          size = [width, height]
        end
      end
    end

    def next_marker(io)
      byte = io.getbyte
      byte = io.getbyte while byte && byte != 0xFF
      byte = io.getbyte while byte == 0xFF
      byte
    end

    # Reads tag 0x0112 from IFD0 of the EXIF TIFF block. `read_at` returns up
    # to `bytes` bytes at `offset` within the block (fewer near its end, "" when
    # out of range).
    def exif_orientation(read_at)
      short, long = case read_at.call(0, 2)
                    when "II" then %w[v V]
                    when "MM" then %w[n N]
                    else return nil
                    end
      offset = read_at.call(4, 4).unpack1(long)
      count = offset && read_at.call(offset, 2).unpack1(short)
      return nil unless count

      # One read for the entry table, bounded by the bytes actually present.
      table = read_at.call(offset + 2, count * 12)
      (table.bytesize / 12).times do |index|
        entry = table.byteslice(index * 12, 12)
        return entry.byteslice(8, 2).unpack1(short) if entry.byteslice(0, 2).unpack1(short) == 0x0112
      end
      nil
    end
  end
end
