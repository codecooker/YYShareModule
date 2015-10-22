//
//  YYSocialMenuViewController.h
//  Hermes
//
//  Created by 吕 鹏伟 on 14-4-25.
//
//

#import <UIKit/UIKit.h>
#import "YYSocialDataEngine.h"

@class YYSocialData;

@interface YYSocialMenuViewController : UIViewController

//!设置分享平台，但是必须依赖于app支持的分享平台
@property (nonatomic,strong) NSArray *supportSharedPlatforms;

//!调起默认分享页面
- (void)shareSocialData : (YYSocialData*)data InCtl : (UIViewController*)ctl onResponse : (YYSocialDataShareResponse)response;

@end
