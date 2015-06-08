module MotionAssets
  class Utils
    class << self
      def ratio_for_scale(scale)
        platform_config = Constants.const_get("#{platform}_#{'SCALES'}")
        platform_config[scale][:ratio]
      end

      def platform
        Motion::Project::App.template.upcase
      end

      def root
        File.expand_path '../../..', File.dirname(__FILE__)
      end

      def android?
        platform == :android
      end

      def ios?
        platform == :ios
      end
    end
  end
end
