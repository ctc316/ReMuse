# Uncomment the next line to define a global platform for your project
platform :ios, '10.3'

target 'ReMuse' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ReMuse
  pod 'AudioKit'
  pod 'RangeSeekSlider'
  pod "SoundWave"
  pod 'FDWaveformView'

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
      if ['RangeSeekSlider', 'FDWaveformView'].include? target.name
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end

  installer.pods_project.targets.each do |target|
      if ['SoundWave'].include? target.name
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '4.0'
          end
      end
  end
end
