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
  app.assets.base_icon = "./src_images/icon-1024.png"
  app.assets.icons << "WeirdIcon.png|25x23"
end