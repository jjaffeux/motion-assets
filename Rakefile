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
  app.assets.source_icon = "./src_images/icon-1024.png"
  app.assets.icons << "WeirdIcon.png|25x23"
  app.assets.icons.delete "iTunesArtwork@2x.png"
end
