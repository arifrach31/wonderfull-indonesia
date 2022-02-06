platform :ios, '14.5'
workspace 'WonderfullIndonesia'
use_frameworks!

def shared_pods
  pod 'SnapKit'
  pod 'ShimmerSwift'
end

target 'WonderfullIndonesia' do
  shared_pods
  pod 'Moya', '~> 13.0.1'
  pod 'ObjectMapper'
  pod 'netfox'
  pod 'SwiftLint'
  pod 'RxCocoa'
  pod 'netfox'
  pod 'SVProgressHUD'
  pod 'Kingfisher'
  pod 'Reusable'
end

target 'Common' do 
  shared_pods

  project 'Modules/Common/Common'
end

target 'Core' do 
  pod 'Moya', '~> 13.0.1'
  pod 'ObjectMapper'
  pod 'RxCocoa'
  pod 'netfox'

  project 'Modules/Core/Core'
end
