Pod::Spec.new do |s|
  s.name         = "AutoSQLite.swift"
  s.version      = '0.0.3'
  s.license      = "MIT"
  s.summary      = '自动解析'

  s.homepage         = 'https://github.com/TonyReet/AutoSQLite.swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 
                          'TonyReet' => 'ktonyreet@gmail.com'
  }

  s.source           = { :git => 'https://github.com/TonyReet/AutoSQLite.swift.git', :tag => s.version.to_s}
  
  s.ios.deployment_target = '10.0'

  s.source_files = 'Source/*.swift'

  s.frameworks = 'UIKit','Foundation'

  s.dependency 'SQLite.swift', '~> 0.11.5'

end
