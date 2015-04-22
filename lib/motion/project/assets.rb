require 'mini_magick'

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

module Motion::Project
  class Config
    variable :assets

    def assets
      @assets ||= Motion::Project::Assets.new(self)
    end
  end

  class Assets
    BASE_SPLASH_SIZE = [2028, 2028]
    BASE_IOS_ICON_SIZE = [1024, 1024]
    BASE_ANDROID_ICON_SIZE = [512, 512]

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

    IOS_SPLASHES = %w{
      Default~iphone.png|320x480
      Default@2x~iphone.png|640x960
      Default-Portrait~ipad.png|768x1024
      Default-Portrait@2x~ipad.png|1536x2048
      Default-Landscape~ipad.png|1024x768
      Default-Landscape@2x~ipad.png|2048x1536
      Default-568h@2x~iphone.png|640x1136
      Default-667h.png|750x1334
      Default-736h.png|1242x2208
      Default-Landscape-736h.png|2208x1242
    }

    ANDROID_ICONS = %w{
      drawable-xxxhdpi/icon.png|192x192
      drawable-xxhdpi/icon.png|144x144
      drawable-xhdpi/icon.png|96x96
      drawable-hdpi/icon.png|72x72
      drawable-mdpi/icon.png|48x48
      drawable-ldpi/icon.png|36x36
    }

    ANDROID_SPLASHES = %w{
      drawable-hdpi/splash-land.png|800x480
      drawable-ldpi/splash-land.png|320x200
      drawable-mdpi/splash-land.png|480x320
      drawable-xhdpi/splash-land.png|1280x720
      drawable-xxhdpi/splash-land.png|1600x960
      drawable-xxxhdpi/splash-land.png|1920x1280
      drawable-hdpi/splash-port.png|480x800
      drawable-ldpi/splash-port.png|200x320
      drawable-mdpi/splash-port.png|320x480
      drawable-xhdpi/splash-port.png|720px1280
      drawable-xxhdpi/splash-port.png|960x1600
      drawable-xxxhdpi/splash-port.png|1280x1920
    }

    def initialize(config)
      @config = config
      @images = []
      @icons = Icons.new(config, platform)
      @image_optim = '/Applications/ImageOptim.app/Contents/MacOS/ImageOptim'
      
      if ios?
        @icons << IOS_ICONS
        @splashes = IOS_SPLASHES
      end

      if android?
        config.icon = 'icon.png'
        @icons << ANDROID_ICONS
        @splashes = ANDROID_SPLASHES
      end

      @source_icon = "./src_images/icon.png"
      @source_splash = "./src_images/splash.png"
      @output_dir = @config.resources_dirs.first
    end

    def source_icon=(source_icon)
      @source_icon = source_icon
    end

    def source_splash=(source_splash)
      @source_splash = source_splash
    end

    def output_dir=(output_dir)
      @output_dir = output_dir
    end

    def icons
      @icons
    end

    def splashes
      @splashes
    end

    def generate!
      validate_source_icon!
      validate_source_splash!
      validate_output_dir
      generate_icons
      generate_splashes
      optimize_images
    end

    protected

    def validate_output_dir
      unless File.exist?(@output_dir)
        App.fail "Output directory : #{@output_dir} doesn't exist, please create it."
      end
    end

    def generate_splashes
      App.info "[info]", "Generating splashes..."
      @splashes.each do |splash|
        parts = splash.split('|')
        path = File.join(@output_dir, parts[0])
        FileUtils.mkdir_p(File.dirname(path))
        generate_image(@source_splash, path, parts[1])
        @images << path
        App.info "-", parts[0]
      end
    end

    def generate_icons
      App.info "[info]", "Generating icons..."
      @icons.each do |icon|
        parts = icon.split('|')
        path = File.join(@output_dir, parts[0])
        FileUtils.mkdir_p(File.dirname(path))
        generate_image(@source_icon, path, parts[1])
        @images << path
        App.info "-", parts[0]
      end
    end

    def optimize_images
      if File.exist?(@image_optim)
        App.info "[info]", "Optimizing images..."
        system("#{@image_optim} #{@images.join(' ')}")
      else
        App.info "[warning]", "motion-assets uses ImageOptim to optimize your images, please install it : https://imageoptim.com"
      end
    end

    def generate_image(source, path, dimensions)
      image = MiniMagick::Image.open(source)
      image.resize(dimensions)
      image.format("png")
      image.write(path)
    end

    def validate_source_icon!
      unless File.exist?(@source_icon)
        App.fail "You have to provide a valid base icon in your rakefile : app.assets.source_icon = './some/path/image.png"
      end
      image = MiniMagick::Image.open(@source_icon)
      if ios? && image.dimensions != BASE_IOS_ICON_SIZE
        App.info "[warning]", "Your source icon image dimensions #{image.dimensions} is different from recommended dimensions : #{BASE_IOS_ICON_SIZE}"
      end
      if android? && image.dimensions != BASE_ANDROID_ICON_SIZE
        App.info "[warning]", "Your source icon image dimensions #{image.dimensions} is different from recommended dimensions : #{BASE_ANDROID_ICON_SIZE}"
      end
    end

    def validate_source_splash!
      unless File.exist?(@source_splash)
        App.fail "You have to provide a valid base splash in your rakefile : app.assets.source_splash = './some/path/image.png"
      end
      image = MiniMagick::Image.open(@source_splash)
      if image.dimensions != BASE_SPLASH_SIZE
        App.info "[warning]", "Your source splash image dimensions #{image.dimensions} is different from recommended dimensions : #{BASE_SPLASH_SIZE}"
      end
    end

    def android?
      platform == :android
    end

    def ios?
      platform == :ios
    end

    def platform
      Motion::Project::App.template
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
