/!\ Alpha code will break a lot in the coming week


# motion-assets

motion-assets allows RubyMotion projects to use ImageMagick to generate all the icons and splash screens sizes.


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

## Setup

In the `Rakefile`, set paths for your base images :

```ruby
Motion::Project::App.setup do |app|
  # ...
  app.assets.source_icon = "./src_images/icon-1024x1024.png"
  app.assets.source_splash = "./src_images/splash-2028x2028.png"
  
  # optional
  app.assets.output_dir = "./some/directory"
end
```

## Configuration

```ruby
Motion::Project::App.setup do |app|
  # Add or remove icons
  app.assets.icons << 'CustomSize.png|32x32'
  app.assets.icons.delete('Icon-60@2x.png|120x120')

  # Disable optimization
  app.assets.optimize = false
end
```

Note : motion-assets will autopopulate your `app.icons` array with the list of created icons.

## Tasks

To tell motion-assets to generate the assets :

```
$ [bundle exec] rake assets:generate
```


note : the sample icon comes from the great Pixelmator tool, http://www.pixelmator.com/
