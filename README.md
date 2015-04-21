# motion-assets

motion-assets allows RubyMotion projects to use ImageMagick to generate all the icons sizes.


## Installation

You need to have ImageMagick installed: 

```
$ brew install imagemagick
```

And the gem installed: 

```
$ [sudo] gem install motion-assets
```

Or if you use Bundler:

```ruby
gem 'motion-assets'
```

Optional, you can install ImageOption to optimize your images : https://imageoptim.com


## Setup

In the `Rakefile`, set the path your base image :

```ruby
Motion::Project::App.setup do |app|
  # ...
  app.assets.source_icon = "./src_images/icon-1024x1024.png"
end
```

## Configuration

You can add or remove icons :

```ruby
Motion::Project::App.setup do |app|
  # ...
  app.assets.icons << 'CustomSize.png|32x32'
  app.assets.icons.delete('Icon-60@2x.png|120x120')
end
```

## Tasks

To tell motion-assets to generate the assets :

```
$ [bundle exec] rake assets:generate
```


note : the sample icon comes from the greal Pixelmator tool, http://www.pixelmator.com/
