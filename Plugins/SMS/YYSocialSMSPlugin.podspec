Pod::Spec.new do |s|

  s.name          = "YYSocialSMSPlugin"
  s.version       = "0.0.1"

  s.summary       = "分享模SMS插件"
  s.description   = <<-DESC
                   分享模块SMS插件，引入后则可支持SMS分享,支持图片和文字分享
                   DESC

  s.homepage      = "http://codecooker.cn/2015/10/iOS%E5%88%86%E4%BA%AB%E5%BC%95%E6%93%8E.html"
  s.authors       = { "codecooker" => "codecooker@outlook.com" }
  s.license       = {
                      :type => 'Copyright',
                      :text => <<-LICENSE
                                Alibaba-INC copyright
                                LICENSE
                    }
  
  s.platform      = :ios, "5.0"
  s.osx.deployment_target = "10.7"

  s.source_files = "**/*.{h,m,c,mm,cpp}"
  s.resources     = "Resources/**/*.{plist,png}"

end