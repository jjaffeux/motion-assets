class Icons
  include Enumerable

  def initialize(config)
    @list = []
    @config = config
  end

  def list
    @list
  end

  def <<(*icons)
    @list << icons
    @list.flatten!
    icons.flatten.each do |icon|
      @config.icons << icon.split('|').first
    end
    self
  end
  alias_method :push, :<<

  def delete(*icons)
    @list.delete(icons)
    @list.flatten!
    icons.flatten.each do |icon|
      @config.icons.delete icon.split('|').first
    end
    self
  end

  def each(&block)
    @list.each(&block)
  end
end
