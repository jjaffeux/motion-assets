unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

module Motion::Project
  class Config
    def setup_assets(&block)
      @assets ||= MotionAssets::Assets.new(self)
      @assets.instance_eval(&block)
      @assets.configure_project
      @assets
    end

    def assets
      @assets
    end
  end
end

namespace :assets do
  desc "Download and build dependencies"
  task :create do
    assets = App.config.assets
    assets.create!
  end
end
