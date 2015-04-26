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
      icon.png|57x57
      icon@2x.png|114x114
      icon-40.png|40x40
      icon-40@2x.png|80x80
      icon-50.png|50x50
      icon-50@2x.png|100x100
      icon-60.png|60x60
      icon-60@2x.png|120x120
      icon-60@3x.png|180x180
      icon-72.png|72x72
      icon-72@2x.png|144x144
      icon-76.png|76x76
      icon-76@2x.png|152x152
      icon-small.png|29x29
      icon-small@2x.png|58x58
      icon-small@3x.png|87x8
    }

    IOS_SPLASHES = %w{
      Default-568h@2x~iphone.png|640x1136
      Default-667h.png|750x1334
      Default-736h.png|1242x2208
      Default-Landscape-736h.png|2208x1242
      Default-Landscape@2x~ipad.png|2048x1536
      Default-Landscape~ipad.png|1024x768
      Default-Portrait@2x~ipad.png|1536x2048
      Default-Portrait~ipad.png|768x1024
      Default@2x~iphone.png|640x960
      Default~iphone.png|320x48
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
      drawable-xhdpi/splash-port.png|720x1280
      drawable-xxhdpi/splash-port.png|960x1600
      drawable-xxxhdpi/splash-port.png|1280x1920
    }

    def initialize(config)
      @config = config
      @optimize = true
      @assets = []
      @source_images = []
      @icons = Icons.new(@config, platform)
      
      if ios?
        @icons << IOS_ICONS
        @splashes = IOS_SPLASHES
      end

      if android?
        @config.icon = 'icon.png'
        @icons << ANDROID_ICONS
        @splashes = ANDROID_SPLASHES
      end

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

    def source_images
      @source_images
    end

    def optimize=(optimize)
      @optimize = optimize
    end

    def icons
      @icons
    end

    def icons=(icons)
      @icons = Icons.new(@config, platform)
      if ios?
        @config.icons = []
      end
      @icons << icons
    end

    def splashes
      @splashes
    end

    def generate!
      validate_output_dir

      if @source_icon
        validate_source_icon
        generate_icons
      end

      if @source_splash
        validate_source_splash
        generate_splashes
      end

      if !@source_images.empty?
        generate_images
      end

      optimize
    end

    protected

    def validate_output_dir
      unless File.exist?(@output_dir)
        App.fail "Output directory : #{@output_dir} doesn't exist, please create it."
      end
    end

    def generate_images
      App.info "[info]", "Generating images..."
      @source_images.flatten.each do |source_image|
        extension = File.extname(source_image)
        filename = File.basename(source_image, extension)
        base_dimensions = MiniMagick::Image.open(source_image).dimensions
        ["2x", "3x"].each do |scale|
          if scale == "2x"
            resized_dimensions = base_dimensions.collect{|n| n / 2}
            dimensions =  "#{resized_dimensions[0]}x#{resized_dimensions[1]}"
          end
          dimensions = "#{base_dimensions[0]}x#{base_dimensions[1]}" if scale == "3x"

          destination = "#{filename}@#{scale}.png"
          path = File.join(@output_dir, 'motion-assets', destination)
          FileUtils.mkdir_p(File.dirname(path))
          image = MiniMagick::Image.open(source_image)
          image.resize(dimensions)
          image.format("png")
          image.write(path)

          @assets << path
          App.info "-", destination
        end
      end
    end

    def generate_splashes
      App.info "[info]", "Generating splashes..."
      @splashes.each do |splash|
        parts = splash.split('|')
        path = File.join(@output_dir, parts[0])
        FileUtils.mkdir_p(File.dirname(path))
        crop_image(@source_splash, path, parts[1])
        @assets << path
        App.info "-", parts[0]
      end
    end

    def generate_icons
      App.info "[info]", "Generating icons..."
      @icons.each do |icon|
        path = File.join(@output_dir, icon.name)
        FileUtils.mkdir_p(File.dirname(path))
        resize_image(@source_icon, path, icon.dimensions)
        @assets << path
        App.info "-", icon.name
      end
    end

    def optimize
      return unless @optimize
      App.info "[info]", "Optimizing assets..."
      assets = @assets.join(' ')
      pngquant = "./vendor/pngquant -f --ext .png --speed=2 --skip-if-larger #{assets}"
      `#{pngquant}`
      optipng = "./vendor/optipng -clobber -quiet #{assets}"
      `#{optipng}`
    end

    def resize_image(source, path, dimensions)
      image = MiniMagick::Image.open(source)
      image.resize(dimensions)
      image.format("png")
      image.write(path)
    end

    def crop_image(source, path, dimensions)
      image = MiniMagick::Image.open(source)
      result = image.combine_options do |cmd|
        cmd.gravity(:center)
        cmd.crop("#{dimensions}!+0+0")
      end
      result.format("png")
      result.write(path)
    end

    def validate_source_icon
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

    def validate_source_splash
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
