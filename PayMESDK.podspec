#
# Be sure to run `pod lib lint PayMESDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PayMESDK'
  s.version          = '0.9.66'
  s.summary          = 'PayME SDK là bộ thư viện để các app có thể tương tác với PayME Platform. PayME SDK bao gồm các chức năng chính như sau.'
  s.swift_versions   = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  PayME SDK là bộ thư viện để các app có thể tưow̛ng tác với PayME Platform. PayME SDK bao gồm các chức năng chính như sau:
  + Hệ thống đăng ký, đăng nhập, eKYC thông qua tài khoản ví PayME
  + Chức năng nạp rút chuyển tiền từ ví PayME.cd ..
  + Tích hợp các dịch vụ của PayME Platform.
                       DESC

  s.homepage         = 'https://payme.vn/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HuyOpen' => 'huytq@payme.vn' }
  s.source           = { :git => 'https://github.com/PayME-Tech/PayME-SDK-IOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.source_files = 'PayMESDK/Classes/**/*'

  s.resource_bundles = {
        'PayMESDK' => ['PayMESDK/Resource/*.png','PayMESDK/Resource/*.json', 'PayMESDK/Resource/*.svg', 'PayMESDK/Resource/*.lproj']
  }
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.frameworks = 'UIKit', 'WebKit', 'Foundation', 'Security'
  s.dependency 'CryptoSwift'
  s.dependency 'SwiftyRSA'
  s.dependency 'Alamofire'
  s.dependency 'lottie-ios', '< 4.0'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'SVGKit'
  s.dependency 'SwiftyJSON'
  s.dependency 'Toast-Swift'
  s.dependency 'PayCardsRecognizer'
end
