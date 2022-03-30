# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'DemoPureCloud' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DemoPureCloud
  pod 'ShimmerSwift'
  pod 'L10n-swift', '~> 5.8'
#  pod 'SmartVideo', '~> 1.10.1'
  pod 'SmartVideo', :git => 'https://github.com/VideoEngager/SmartVideo-iOS-SDK', :branch => "development"
end



post_install do |installer|
  installer.pods_project.targets.each do |target|
      if target.name == "GoogleWebRTC" || target.name == "SmartVideo"
          puts "Processing for disable bit code in #{target.name}"
          target.build_configurations.each do |config|
          	config.build_settings['ENABLE_BITCODE'] = 'NO'
          end
      end
  end
end
