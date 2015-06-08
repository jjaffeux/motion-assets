module MotionAssets
  class Image
    attr_reader :path

    def initialize(path, config_string = "")
      @path = File.expand_path(path)
      @options = ImageConfigParser.parse(config_string.to_s)
    end

    def name
      @name ||= @options['name'] ||=begin
        filename = File.basename(@path)

        if !filename.index('|')
          return filename
        end

        extname = File.extname(@path)
        "#{filename.split('|')[0]}#{extname}"
      end
    end

    def format
      @format ||= @options['format'] || File.extname(@path)
    end

    def base_ratio
      @base_ratio ||= Utils.ratio_for_scale(@options['base_scale'])
    end

    def base_scale
      @options['base_scale']
    end

    def size
      @size ||=begin
        if @options['size']
          return MotionAssets.Size(@options['size'])
        end
        MotionAssets.Size(0, 0)
      end
    end

    def size_for_ratio(ratio)
      size.scale_with_ratio(ratio)
    end

    def bounds_for_ratio(ratio)
      bounds.scale_with_ratio(ratio)
    end

    def bounds
      @bounds ||=begin
        sizes = MiniMagick::Image.open(path).dimensions
        Size.new(sizes[0], sizes[1])
      end
    end

    def scales
      @scales ||= @options['scales'].split('-')
    end

    def name_for_scale(scale)
      extname = File.extname(name)
      name_without_extension = File.basename(name, extname)
      "#{name_without_extension}#{Constants::IOS_SCALES[scale][:suffix]}#{extname}"
    end
  end
end
