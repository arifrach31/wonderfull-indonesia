platform :ios, '14.5'
workspace 'WonderfullIndonesia'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/arifrach31/Wi-Corepodspec'

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
  pod 'Core', :git => 'https://github.com/arifrach31/Wi-Core.git'
end

target 'Common' do 
  shared_pods
  pod 'Core', :git => 'https://github.com/arifrach31/Wi-Core.git'

  project 'Modules/Common/Common'
end