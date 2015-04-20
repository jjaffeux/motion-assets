require 'mini_magick'

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

module Motion::Project
  class Config
    variable :assets

    def assets(&block)
      @assets ||= Motion::Project::Assets.new(self)
      if block
        @assets.instance_eval(&block)
      end
      @assets
    end
  end

  class Assets
    IOS_ICONS = %w{
      Icon-Small.png|29x29
      Icon-Small@2x.png|58x58
      Icon-Small@3x.png|87x87
      Icon-40.png|40x40
      Icon-40@2x.png|80x80
      Icon-40@3x.png|120x120
      Icon-60@2x.png|120x120
      Icon-60@3x.png|180x180
      Icon-76.png|76x76
      Icon-76@2x.png|152x152
      Icon-120.png|120x120
      iTunesArtwork.png|512x512
      iTunesArtwork@2x.png|1024x1024
    }

    ANDROID_ICONS = %w{
      drawable-xxxhdpi/icon.png|192x192x 
      drawable-xxhdpi/icon.png|144x144x 
      drawable-xhdpi/icon.png|96x96x 
      drawable-hdpi/icon.png|72x72x 
      drawable-mdpi/icon.png|48x48x 
      drawable-ldpi/icon.png|36x36x 
    }

    def initialize(config)
      @config = config
      if Motion::Project::App.template != :android
        @icons = IOS_ICONS
      else
        @icons = ANDROID_ICONS
      end
      @base_icon = "./src_images/base_icon.png"
    end

    def base_icon=(base_icon)
      @base_icon = base_icon
    end

    def icons
      @icons
    end

    def generate!
      unless File.exist?(@base_icon)
        App.fail "You have to provide a valid base icon in your rakefile : app.assets.base_icon = './some/path/image.png"
      end

      @icons.each do |icon|
        parts = icon.split('|')
        image = MiniMagick::Image.open(@base_icon)
        image.resize(parts[1])
        image.format("png")
        destination = File.join(@config.resources_dirs.first, parts[0])
        FileUtils.mkdir_p(File.dirname(destination))
        image.write(destination)
      end
    end
  end
end

namespace :assets do
  desc "Download and build dependencies"
  task :generate do
    assets = App.config.assets
    assets.generate!
  end
end