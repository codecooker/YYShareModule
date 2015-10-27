//
//  YYSocialDataEngine.h
//  YYShareModule
//
//  Created by Powell.lui on 12/1/13.
//  Copyright (c) 2013 Powell.lui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYSocialData.h"
#import "YYSocialResponse.h"

@class YYSocialData;


@interface YYSocialDataEngine : NSObject

//单例模式，这个应用拥有一份儿引用
+ (YYSocialDataEngine*)shareInstance;

//!现在未支持的分享渠道,默认为NO,即该分享渠道未支持的话隐藏该分享渠道
@property (nonatomic,assign) BOOL showUnsupportPlugin;

//!支持的分享插件，如果showUnsupportPlugin=yes返回该平台引入的所有分享plugin，如果showUnsupportPlugin=NO，则返回手机上支持的和所有引入的平台的交集
@property (nonatomic,strong,readonly) NSArray *supportPlugins;

//!分享内容到指定平台
- (BOOL)shareSNSData : (YYSocialData*)shareData onResponse : (YYSocialDataShareResponse)response;

//!处理url
- (BOOL)handleOpenURL:(NSURL *)url;

@end
