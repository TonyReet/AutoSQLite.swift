Pod::Spec.new do |s|
  s.name         = "AutoSQLite.swift"
  s.version      = '0.0.2'
  s.license      = "MIT"
  s.summary      = '自动解析'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Swift自动解析
                       DESC

  s.homepage         = 'https://github.com/TonyReet/AutoSQLite.swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 
                          'TonyReet' => 'ktonyreet@gmail.com'
  }

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.source           = { :git => 'https://github.com/TonyReet/AutoSQLite.swift.git', :tag => s.version.to_s}
  
  s.ios.deployment_target = '10.0'

  s.source_files = "../Source/*.{swift}"
  # s.resources    = "DFDSCSDK/Kit/**/*.{xib,nib,storyboard,png}"
  # s.resources    = "DFDSCSDK/**/*.{xib,html,xcdatamodeld,storyboard,plist,bundle,json}"

  s.frameworks = 'UIKit','Foundation'
  
  # s.resource_bundles = {
  #   'DFDSCSDK' =>   ['DFDSCSDK/Bundle.xcassets']
  # }
  
  # s.resources = ['DPSDKKIT/Resources/**/*']
  
  s.dependency 'SQLite.swift', '~> 0.11.5'

# s.prefix_header_file = 'DFDSCSDK/Kit/DFDSCSDK.h'
end
