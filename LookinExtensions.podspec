#
# Be sure to run `pod lib lint LookinExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LookinExtensions'
  s.version          = '1.0.0'
  s.summary          = 'Display more UI info in Lookin.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  - UIView's gesture recognizers
  - UIControl's target-action
  - UIScrollView's delegate and data source
                       DESC

  s.homepage         = 'https://github.com/Magic-Unique/LookinExtensions'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Magic-Unique' => '516563564@qq.com' }
  s.source           = { :git => 'https://github.com/Magic-Unique/LookinExtensions.git', :tag => "#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'LookinExtensions/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LookinExtensions' => ['LookinExtensions/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
