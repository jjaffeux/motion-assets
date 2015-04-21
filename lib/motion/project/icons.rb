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
    icons.flatten.each do |icon|
      @assets_delegate.add_icon(icon.split('|').first)
    end
    self
  end
  alias_method :push, :<<

  def delete(*icons)
    @list.delete(icons)
    @list.flatten!
    icons.flatten.each do |icon|
      @assets_delegate.delete_icon(icon.split('|').first)
    end
    self
  end

  def each(&block)
    @list.each(&block)
  end
end
