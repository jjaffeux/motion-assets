module MotionAssets
  module Constants
    BASE_IOS_ICON_SIZE = [1024, 1024]
    BASE_ANDROID_ICON_SIZE = [512, 512]

    IOS_SCALES = {
      '@1x' => {ratio: 1.0, suffix: ""},
      '@2x' => {ratio: 2.0, suffix: "@2x"},
      '@3x' => {ratio: 3.0, suffix: "@3x"}
    }

    IOS_ICONS = [
      'name=icon.png,size=57x57,scales=@1x-@2x',
      'name=icon-40.png,size=40x40',
      'name=icon-72.png,size=72x72,scales=@1x-@2x',
      'name=icon-76.png,size=76x76,scales=@1x-@2x',
      'name=icon-60.png,size=60x60,scales=@2x-@3x',
      'name=icon-small.png,size=58x58,base_scale=@2x'
    ]

    ANDROID_SCALES = [
      {name: 'ldpi', ratio: 0.75},
      {name: 'mdpi', ratio: 1.0},
      {name: 'hdpi', ratio: 1.5},
      {name: 'xhdpi', ratio: 2.0},
      {name: 'xxhdpi', ratio: 3.0},
      {name: 'xxxhdpi', ratio: 4.0}
    ]

    ANDROID_ICONS = ANDROID_SCALES.map do |scale|
      edge = (48 * scale[:ratio]).to_i
      "drawable-#{scale[:name]}/icon.png|#{edge}x#{edge}"
    end
  end
end
