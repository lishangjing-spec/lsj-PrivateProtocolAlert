#
# Be sure to run `pod lib lint lsj-PrivateProtocolAlert.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'lsj-PrivateProtocolAlert'
  s.version          = '0.1.0'
  s.summary          = 'A short description of lsj-PrivateProtocolAlert.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "隐私政策弹窗"

  s.homepage         = 'https://github.com/lishangjing-spec/lsj-PrivateProtocolAlert'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lsj' => '534016847@qq.com' }
  s.source           = { :git => 'https://github.com/lsj/lsj-PrivateProtocolAlert.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'lsj-PrivateProtocolAlert/Classes/**/*'
  
  # s.resource_bundles = {
  #   'lsj-PrivateProtocolAlert' => ['lsj-PrivateProtocolAlert/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
