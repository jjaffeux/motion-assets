# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  app.name = 'Assets'
  app.assets.output_dir = "./test"
  app.assets.source_icon = "./src_images/icon-1024.png"
  app.assets.source_splash = "./src_images/splash-2028.png"
  app.assets.icons.push "WeirdIcon.png|25x23"
  app.assets.icons.delete "iTunesArtwork@2x.png"
end
