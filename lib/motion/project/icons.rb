class Icons
  include Enumerable
  Struct.new("Icon", :name, :dimensions)

  def initialize(config, platform)
    @list = []
    @config = config
    @platform = platform
  end

  def list
    @list
  end

  def <<(*icons)
    icons.flatten.each do |icon_string|
      icon = create_icon(icon_string)
      @list << icon

      if @platform == :ios
        @config.icons << icon.name
      end
    end
    self
  end
  alias_method :push, :<<

  def delete(*icons)
    icons.flatten.each do |icon_string|
      icon = @list.find {|icon| icon.name == icon_string}

      if @platform == :ios
        @config.icons.delete icon.name
      end

      @list.delete(icon)
    end
    self
  end

  def each(&block)
    @list.each(&block)
  end

  protected

  def create_icon(icon_string)
    parts = icon_string.split('|')
    Struct::Icon.new(parts[0], parts[1])
  end
end
