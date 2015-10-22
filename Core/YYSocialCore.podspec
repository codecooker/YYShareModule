Pod::Spec.new do |s|

  s.name          = "YYSocialCore"
  s.version       = "0.0.1"

  s.summary       = "分享引擎的核心模块，分享模块的基础"
  s.description   = <<-DESC
                   分享引擎的核心模块，FDF内分享模块的基础。定义了分享模块内的基础数据结构和分享插件的接口
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