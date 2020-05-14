#
# Be sure to run `pod lib lint FMCollectionLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FMCollectionLayout'
  s.version          = '1.0.9'
  s.summary          = '一个CollectionView自定义布局框架, 支持多种布局方式, 让你专心处理业务逻辑'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
特斯拉组件优化更新  懒加载  以及动画增加
                       DESC

  s.homepage         = 'https://github.com/CoderFM/FMCollectionLayout'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '周发明' => 'zhoufaming251@163.com' }
  s.source           = { :git => 'https://github.com/CoderFM/FMCollectionLayout.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'FMCollectionLayout/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FMCollectionLayout' => ['FMCollectionLayout/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
