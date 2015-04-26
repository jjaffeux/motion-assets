# This is just so that the source file can be loaded.
module ::Motion; module Project; class Config
  def self.variable(*); end
end; end; end

require 'date'
$:.unshift File.expand_path('../lib', __FILE__)
require 'motion/project/version'

Gem::Specification.new do |spec|
  spec.name        = 'motion-assets'
  spec.version     = Motion::Project::Assets::VERSION
  spec.date        = Date.today
  spec.summary     = 'Generate icons from a base image'
  spec.description = "motion-assets leverages the power of ImageMagick to generate all icon sizes for your app."
  spec.author      = 'Joffrey Jaffeux'
  spec.email       = 'j.jaffeux@gmail.com'
  spec.homepage    = 'http://www.rubymotion.com'
  spec.license     = 'MIT'

  spec.files       = (Dir.glob('lib/**/*.rb') << 'README.md' << 'LICENSE').concat Dir.glob('vendor/**/*')
  spec.add_dependency('mini_magick')
end
