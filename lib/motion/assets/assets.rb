module MotionAssets
  class Assets
    include Constants

    attr_accessor :optimize

    def initialize(config)
      @config = config
      @optimize = true
      @assets = []
      @source_images = []
      @images = []
      @icons = []
      @output_dir = @config.resources_dirs.first
    end

    def configure_project
      if @source_icon
        @config.icon = 'icon.png' if Utils.android?
        Assets.const_get("#{Utils.platform.upcase}_#{'ICONS'}").each do |options|
          @icons << icon = Image.new(@source_icon, options)
        end
      end

      @source_images.flatten.map do |image_path|
        @images << Image.new(image_path, image_path.split('|')[1])
      end

      @config.icons = @icons.map(&:name)# if Utils.ios?
    end

    def icons=(icons)
      icons.each do |icon_path|
        @icons << Image.new(icon_path, icon_path.split('|')[1])
      end
    end

    def source_icon=(source_icon)
      @source_icon = File.expand_path(source_icon)
    end

    def output_dir=(output_dir)
      @output_dir = File.expand_path(output_dir)
    end

    def source_images
      @source_images
    end

    def create!
      if @source_icon
        validate_source_icon
        create_icons
      end

      if !@source_images.empty?
        create_images
      end

      optimize_assets if @optimize
    end

    protected

    def create_images
      App.info "[info]", "Generating images..."
      @images.flatten.each do |image|
        image.scales.each do |scale|
          destination = File.join(@output_dir, 'motion-assets', image.name_for_scale(scale))
          ratio = Utils.ratio_for_scale(scale)
          transformations = Transformations.new(image, destination)
          if image.size.nil?
            transformations.resize_to_ratio!(ratio / image.base_ratio)
          else
            transformations.resize_to_ratio!(ratio / image.base_ratio)
            bounds_for_1x = image.bounds.convert_to_ratio(1.0, image.base_ratio)
            if bounds_for_1x != image.size
              transformations.extent_to_size(image.size.convert_to_ratio(ratio, 1.0))
            end
          end
          transformations.save!
          @assets << destination
          App.info "-", image.name_for_scale(scale)
        end
      end
    end

    def create_icons
      App.info "[info]", "Generating icons..."
      @icons.each do |icon|
        icon.scales.each do |scale|
          destination = File.join(@output_dir, icon.name_for_scale(scale))
          transformations = Transformations.new(icon, destination)
          transformations.resize_to_size!(icon.size.scale_with_ratio(Utils.ratio_for_scale(scale)))
          transformations.save!
          @assets << destination
          App.info "-", icon.name_for_scale(scale)
        end
      end
    end

    def optimize_assets
      App.info "[info]", "Optimizing assets..."
      assets = @assets.join(' ')
      `#{Utils.root}/vendor/pngquant -f --ext .png --speed=2 --skip-if-larger #{assets}`
      `#{Utils.root}/vendor/optipng -clobber -quiet #{assets}`
    end

    def validate_source_icon
      unless File.exist?(@source_icon)
        App.fail "You have to provide a valid base icon in your rakefile : app.assets.source_icon = './some/path/image.png"
      end
      image = MiniMagick::Image.open(@source_icon)
      if Utils.ios? && image.dimensions != BASE_IOS_ICON_SIZE
        App.info "[warning]", "Your source icon image dimensions #{image.dimensions} is different from recommended dimensions : #{BASE_IOS_ICON_SIZE}"
      end
      if Utils.android? && image.dimensions != BASE_ANDROID_ICON_SIZE
        App.info "[warning]", "Your source icon image dimensions #{image.dimensions} is different from recommended dimensions : #{BASE_ANDROID_ICON_SIZE}"
      end
    end
  end
end
