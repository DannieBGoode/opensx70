#!/usr/bin/env ruby

require "find"

CONTENT_ROOTS = %w[_posts _pages _tutorials _products _layouts _includes].freeze
CONTENT_FILES = %w[feed.xml].freeze
IMAGE_EXTENSIONS = %w[.avif .gif .jpeg .jpg .png .webp].freeze
MAX_IMAGE_BYTES = Integer(ENV.fetch("MAX_PUBLIC_IMAGE_BYTES", "25000000"), 10)
LARGE_IMAGE_BYTES = Integer(ENV.fetch("REPORT_LARGE_IMAGE_BYTES", "5000000"), 10)

inline_images = []
large_images = []
image_count = 0

CONTENT_ROOTS.each do |root|
  next unless Dir.exist?(root)

  Find.find(root) do |path|
    next unless File.file?(path)

    extension = File.extname(path).downcase
    if %w[.html .md .markdown .mkd .yml].include?(extension)
      inline_images << path if File.binread(path).include?("data:image/")
    end
  end
end

CONTENT_FILES.each do |path|
  inline_images << path if File.file?(path) && File.binread(path).include?("data:image/")
end

if Dir.exist?("img")
  Find.find("img") do |path|
    next unless File.file?(path)
    next unless IMAGE_EXTENSIONS.include?(File.extname(path).downcase)

    bytes = File.size(path)
    image_count += 1
    if bytes > MAX_IMAGE_BYTES
      abort("Media budget exceeded: #{path} is #{bytes} bytes (limit #{MAX_IMAGE_BYTES}).")
    end
    large_images << [bytes, path] if bytes > LARGE_IMAGE_BYTES
  end
end

unless inline_images.empty?
  warn "Inline image data is not allowed in content:"
  inline_images.each { |path| warn "  - #{path}" }
  exit 1
end

puts "Media budget OK: #{image_count} public images checked; no inline image payloads found."
unless large_images.empty?
  puts "Large images to review (over #{LARGE_IMAGE_BYTES} bytes):"
  large_images.sort.reverse_each do |bytes, path|
    puts format("  - %8.1f KB  %s", bytes / 1024.0, path)
  end
end
