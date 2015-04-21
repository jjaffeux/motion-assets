class Icons
  include Enumerable

  def initialize(assets_delegate)
    @list = []
    @assets_delegate = assets_delegate
  end

  def names
    @list.map {|icon| icon.split('|').first}
  end

  def list
    @list
  end

  def <<(*icons)
    @list << icons
    @list.flatten!
    @list.each do |icon|
      @assets_delegate.add_icon(icon.split('|').first)
    end
    self
  end

  def each(&block)
    @list.each(&block)
  end
end
