require File.expand_path('../spec_helper', __FILE__)

describe "Image" do
  before do
    @path = './src_assets/images/icon.png'
    @subject = MotionAssets::Image.new(@path, 'size=57x57,scales=@1x-@2x')
  end

  it "has a path" do
    @subject.path.should == File.expand_path(@path)
  end

  it "has a name" do
    @subject.name.should == 'icon.png'
  end

  it "has a size" do
    @subject.size.width.should == 57
    @subject.size.height.should == 57
  end

  it "has a base scale" do
    @subject.base_scale.should == '@1x'
  end

  it "has scales" do
    @subject.scales.should == ['@1x', '@2x']
  end

  it "has a with config embeded" do
    @path = './src_assets/images/profile|22x22.png'
    @subject = MotionAssets::Image.new(@path, 'size=57x57,scales=@1x-@2x')
    @subject.name.should == 'profile.png'
  end
end
