//
//  YYSocialPlugin.h
//  Pods
//
//  Created by codecooker on 15/7/7.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYSocialData.h"
#import "YYSocialResponse.h"

#ifndef __YYSocialPluginBlock__

@class YYSocialPlugin;
@class YYSocialPluginScene;

typedef void(^YYSocialPluginOnLoad)(YYSocialPlugin* plugin);

#endif

@interface YYSocialPlugin : NSObject

//!plugin对应的type，在分享内容时，该data内的type必须和该type对应
@property (nonatomic,assign) YYSocialDataType type;

//!调用分享组件后的response
@property (nonatomic,strong) YYSocialResponse *response;

//!该plugin是否被支持,默认为全支持
@property (nonatomic,assign,readonly) BOOL isPluginSupport;

//!分享时如果必须要上传图片时的默认图片,需要png格式，不可传后缀名
@property (nonatomic,strong) NSString *defaultImage;

//!分享时如果必须要上传url时的默认url
@property (nonatomic,strong) NSString *defaultUrl;

//!appkey
@property (nonatomic,strong) NSString *appKey;

//!appSecretKey
@property (nonatomic,strong) NSString *appSecretKey;

//!appDes
@property (nonatomic,strong) NSString *appDes;

//!加载plugin,一般在该方法内初始化分享模块，如设置appkey等数据
- (void)loadPlugin;

//!根据生成的分享内容，分享到对应平台,子类需要根据不同的分享sdk完成分享方法的实现
- (void)shareWithData : (YYSocialData *)socialData onResponse : (YYSocialDataShareResponse)response;

//!处理远程连接启动app，或是分享返回时
- (BOOL)handleOpenURL:(NSURL *)url;

//!将应用注册给第三方分享sdk，不要显式调用，系统会自己触发，需要根据平台来实现注册代码
- (void)registerPluginWithAppKey : (NSString *)appKey appSecretKey : (NSString *)appSecretKey appDes : (NSString *)appDes;

@end
