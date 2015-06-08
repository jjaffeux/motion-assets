require File.expand_path('../spec_helper', __FILE__)

describe "ImageConfigParser" do
  it "retrieves name" do
    subject = MotionAssets::ImageConfigParser.parse('name=icon.png,size=57x57')
    subject['name'].should == 'icon.png'
  end

  it "retrieves size" do
    subject = MotionAssets::ImageConfigParser.parse('size=57x57,scales=@1x-@2x')
    subject['size'].should == '57x57'
  end

  it "retrieves scales" do
    subject = MotionAssets::ImageConfigParser.parse('size=57x57,scales=@1x')
    subject['scales'].should == '@1x'
  end

  it "retrieves default scales" do
    subject = MotionAssets::ImageConfigParser.parse('size=57x57,base_scale=@3x')
    subject['scales'].should == '@1x-@2x-@3x'
  end

  it "retrieves default base scale" do
    subject = MotionAssets::ImageConfigParser.parse('size=57x57,base_scale=@3x')
    subject['base_scale'].should == '@3x'
  end

  it "retrieves base scale" do
    subject = MotionAssets::ImageConfigParser.parse('size=57x57,scales=@1x-@2x')
    subject['base_scale'].should == '@1x'
  end
end
