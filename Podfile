# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'DevRev-Assignment-Gourav-Ray' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DevRev-Assignment-Gourav-Ray
   pod 'MBProgressHUD'
   pod 'SDWebImage', '~> 5.0'
   pod 'Toast-Swift', '~> 5.0.1'
   pod 'Kingfisher', '~> 7.0'

  target 'DevRev-Assignment-Gourav-RayTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DevRev-Assignment-Gourav-RayUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
