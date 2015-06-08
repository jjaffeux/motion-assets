module MotionAssets
  class ImageConfigParser
    attr_reader :options, :name

    def self.parse(config_string = "")
      default_options = {
        'base_scale' => '@3x',
        'scales' => '@1x-@2x-@3x'
      }

      extname = File.extname(config_string)
      options = {'format' => extname}
      (config_string.split(',') || [])
        .map! {|option| option.split('=')}
        .each {|option| options[option[0]] = option[1]}

      default_options.merge(options)
    end
  end
end
