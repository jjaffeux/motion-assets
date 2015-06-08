module MotionAssets
  class Transformations
    def initialize(image, destination)
      @image = image
      @destination = destination
      @magick = MiniMagick::Image.open(image.path)
      @magick.format(image.format[1..-1])
    end

    def resize_to_ratio!(ratio)
      @magick.resize(@image.bounds_for_ratio(ratio).to_s)
    end

    def resize_to_size!(size)
      @magick.resize(size.to_s)
    end

    def extent_to_size(size)
      @magick = @magick.combine_options do |cmd|
        cmd.background(:none)
        cmd.gravity(:center)
        cmd.extent(size.to_s)
      end
    end

    def save!
      FileUtils.mkdir_p(File.dirname(@destination))
      @magick.write(@destination)
    end
  end
end
