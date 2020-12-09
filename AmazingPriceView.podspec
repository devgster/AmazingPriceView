#
# Be sure to run `pod lib lint AmazingPriceView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AmazingPriceView'
  s.version          = '1.0.1'
  s.summary          = 'It is a library with animation that comes down as the number is alpha-blended every time you enter a number.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'It is a library with animation that comes down as the number is alpha-blended every time you enter a number. You can get the price information entered on the screen and set the maximum price, minimum price, animation time, and place holder. You can handle the status of the view at the maximum & minimum price in the delegate functions.'

  s.homepage         = 'https://github.com/yoosa3004/AmazingPriceView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yoosa3004' => 'yoosa3004@deali.net' }
  s.source           = { :git => 'https://github.com/yoosa3004/AmazingPriceView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.2'

  s.source_files = 'AmazingPriceView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AmazingPriceView' => ['AmazingPriceView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
