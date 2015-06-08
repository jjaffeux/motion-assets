# require File.expand_path('../spec_helper', __FILE__)

# module Motion; module Project;
#   class Config
#     attr_writer :project_dir
#   end
# end; end

# describe "motion-assets" do
#   extend SpecHelper::TemporaryDirectory

#   before do
#     unless @ran_install
#       teardown_temporary_directory
#       setup_temporary_directory

#       context = self


#       # @config = App.config
#       # @config.project_dir = temporary_directory.to_s
#       # @config.instance_eval do
#       #   assets.source_icon = "./src_assets/icon-1024.png"
#       #   assets.icons.push "WeirdIcon.png|25x25"
#       #   assets.icons.delete "icon-small.png"
#       #   assets.optimize = false
#       #   assets.output_dir = project_dir
#       #   assets.source_images << Dir.glob("./src_assets/images/**/*.png")
#       # end

#       # Rake::Task['assets:generate'].invoke


#     end
#   end

#   it "lol" do
#     parser = MotionAssets::ImageParser.new('icon.png|size=57x57,scales=@1x-@2x')
#     p parser.options
#     p parser.scales
#   end

#   # it "should create images for all scales" do
#   #   MotionAssets::Config::IOS_SCALES.each do |scale|
#   #     file = File.join(temporary_directory.to_s, "motion-assets", "pin#{scale[:name]}.png")
#   #     File.exist?(file).should == true
#   #   end
#   # end

#   # it "should create icons with expected dimensions" do
#   #   ios_icons = Motion::Project::Assets::IOS_ICONS - 
#   #   ['icon-small.png|29x29'] + 
#   #   ['WeirdIcon.png|25x25']

#   #   ios_icons.each do |ios_icon|
#   #     parts = ios_icon.split('|')
#   #     name = parts[0]
#   #     expected_dimensions = parts[1].split('x').map(&:to_i)
#   #     destination = File.join(temporary_directory.to_s, name)
#   #     actual_dimensions = MiniMagick::Image.open(destination).dimensions
#   #     expected_dimensions.should == actual_dimensions
#   #   end
#   # end
# end
