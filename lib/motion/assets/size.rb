module MotionAssets
  module_function
  def Size(*args)
    case args.first
    when Integer then Size.new(*args)
    when String  then Size.new(*args.first.split('x').map(&:to_i))
    when ->(arg){ arg.respond_to?(:to_size) }
      args.first.to_size
    when ->(arg){ arg.respond_to?(:to_ary) }
      Size.new(*args.first.to_ary)
    else
      raise TypeError, "Cannot convert #{args.inspect} to Size"
    end
  end

  class Size
    attr_accessor :width, :height

    def initialize(width, height)
      @width = width
      @height = height
    end

    def nil?
      self.width == 0 || self.height == 0
    end

    def square?
      self.width == self.height
    end

    def to_s
      "#{self.width}x#{self.height}"
    end

    def to_size
      self
    end

    def <=>(other_size)
      self.width == other_size.width && self.height == other_size.height 
    end

    def scale_with_ratio(ratio)
      Size.new(self.width * ratio, self.height * ratio)
    end

    def convert_to_ratio(new_ratio, base_image_ratio)
      Size.new(
        ((self.width / base_image_ratio) * new_ratio).round,
        ((self.height / base_image_ratio) * new_ratio).round
      )
    end
  end  
end
