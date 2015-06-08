require File.expand_path('../spec_helper', __FILE__)

describe "Size" do
  it "accepts a string `xx:xx` as argument" do
    subject = MotionAssets.Size('25x50')
    subject.width.should == 25
    subject.height.should == 50
  end

  it "accepts an array as argument" do
    subject = MotionAssets.Size([25, 50])
    subject.width.should == 25
    subject.height.should == 50
  end

  it "accepts two parameters (width, height) as arguments" do
    subject = MotionAssets.Size(25, 50)
    subject.width.should == 25
    subject.height.should == 50
  end

  it "accepts another Size as argument" do
    subject = MotionAssets.Size(MotionAssets::Size.new(25, 50))
    subject.width.should == 25
    subject.height.should == 50
  end
end
