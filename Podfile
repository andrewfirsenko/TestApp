platform :ios, '10.0'

target 'TestApp' do

  # Pods for TestApp
  pod 'SwiftGen'
  pod 'CSwiftLog'
  
  pod 'SkeletonView'
  pod 'SDWebImage'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
    end
  end
end
