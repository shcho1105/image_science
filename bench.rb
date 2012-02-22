#!/usr/local/bin/ruby -w

require 'benchmark'
require 'rubygems'
require './lib/image_science.rb'

file = ARGV.shift
abort "Usage: #{__FILE__} max_iteration image_file" if file.nil?
ext = File.extname(file)
ImageScience.with_image(file) do |img|
  img.save(file = file.chomp(ext) + ".png")
end if ext != ".png"

max = (ARGV.shift || 100).to_i

puts "# of iterations = #{max}"
Benchmark::bm(20) do |x|
  x.report("null_time") {
    max.times do 
      # do nothing
    end
  }

  x.report("cropped") {
    max.times do 
      ImageScience.with_image(file) do |img|
        img.cropped_thumbnail(100) do |thumb|
          thumb.save("cropped_#{file}")
        end
      end
    end
  }

  x.report("proportional") {
    max.times do
      ImageScience.with_image(file) do |img|
        img.thumbnail(100) do |thumb|
          thumb.save("thumb_#{file}")
        end
      end
    end
  }

  x.report("resize") {
    max.times do
      ImageScience.with_image(file) do |img|
        img.resize(200, 200) do |resize|
          resize.save("resized_#{file}")
        end
      end
    end
  }
end

# File.unlink(*Dir["blah*#{ext}"])
