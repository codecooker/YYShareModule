Pod::Spec.new do |s|

  s.name          = "YYSocialEngine"
  s.version       = "0.0.1"

  s.summary       = "分享模块引擎，用于分配调度各个插件模块"
  s.description   = <<-DESC
                   分享模块引擎，定义了分享模块插件的注册方式。完成分享模块的扩展和调度工作
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
  s.requires_arc  = true

end