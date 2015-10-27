//
//  YYSocialPlugin.m
//  YYShareModule
//
//  Created by codecooker on 15/7/7.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYSocialPlugin.h"
#import <objc/runtime.h>

#define kPluginOnLoadHook                    "YYSocialPluginOnLoad"

@implementation YYSocialPlugin
{
    YYSocialDataShareResponse _socialDataShareResponse;
}

@synthesize response        = _response;

+ (YYSocialPlugin *)plugin {
    static YYSocialPlugin *plugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!plugin) {
            plugin = [[YYSocialPlugin alloc]init];
        }
    });
    return plugin;
}


- (void)shareWithData:(YYSocialData *)socialData onResponse:(YYSocialDataShareResponse)response {
    _socialDataShareResponse = response;
}

- (void)loadPlugin {
    YYSocialPluginOnLoad onLoad = objc_getAssociatedObject([self class], kPluginOnLoadHook);
    if (onLoad) {
        onLoad(self);
    }
    [self registerPluginWithAppKey : self.appKey appSecretKey : self.appSecretKey appDes : self.appDes];
}

- (void)setResponse : (YYSocialResponse *)response {
    if (_socialDataShareResponse) {
        _socialDataShareResponse(response);
        _socialDataShareResponse = nil;
    }
    _response = response;
}

- (void)registerPluginWithAppKey : (NSString *)appKey appSecretKey : (NSString *)appSecretKey appDes : (NSString *)appDes {}

- (BOOL)isPluginSupport {
    return YES;
}

- (BOOL)handleOpenURL:(NSURL *)url{
    return NO;
}
@end
