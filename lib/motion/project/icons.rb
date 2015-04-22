class Icons
  include Enumerable

  def initialize(config, platform)
    @list = []
    @config = config
    @platform = platform

    if platform == :android
      @config.icon = 'icon.png'
    end
  end

  def list
    @list
  end

  def <<(*icons)
    @list << icons
    @list.flatten!

    if @platform == :ios
      icons.flatten.each do |icon|
        @config.icons << icon.split('|').first
      end
    end

    self
  end
  alias_method :push, :<<

  def delete(*icons)
    @list.delete(icons)
    @list.flatten!

    if @platform == :ios
      icons.flatten.each do |icon|
        @config.icons.delete icon.split('|').first
      end
    end

    self
  end

  def each(&block)
    @list.each(&block)
  end
end
