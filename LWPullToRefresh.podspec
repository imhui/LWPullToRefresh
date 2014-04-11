Pod::Spec.new do |s|

  s.name         = "LWPullToRefresh"
  s.version      = "1.0"
  s.summary      = "LWPullToRefresh"
  s.homepage     = "https://github.com/imhui/LWPullToRefresh"
  s.license      = 'MIT'
  s.author       = { "imhui" => "seasonlyh@gmail.com" }
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/imhui/LWPullToRefresh.git", :tag => "1.0" }
  s.source_files  = 'LWPullToRefresh/LWRefreshControl/*.{h,m}'
  s.requires_arc = true

end
