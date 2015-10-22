//
//  YYSocialDataEngine.m
//  YYUIKit
//
//  Created by Powell.lui on 12/1/13.
//  Copyright (c) 2013 Powell.lui. All rights reserved.
//

#import "YYSocialDataEngine.h"
#import "YYSocialData.h"
#import "YYSocialResponse.h"
#import <objc/runtime.h>
#import "YYSocialPlugin.h"

#define kPluginPrefix                       @"YYSocialPlugin:"
#define kPluginClassMaps                     "YYSocialPluginMap"

static NSDictionary *_plugins;

@interface YYSocialDataEngine (){
    NSDictionary* _plugins;
}

@end

@class UMSocialData;

@implementation YYSocialDataEngine

+ (YYSocialDataEngine*)shareInstance
{
    static YYSocialDataEngine* _shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareInstance) {
            _shareInstance = [[YYSocialDataEngine alloc]init];
        }
    });
    return _shareInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self loadPlugin];
    }
    return self;
}

//!选择在初始化的时候加载所有plugin的原因有很多个，其中最重要的原因即是可以在没有调用过分享模块的时候处理从分享平台引流过来的操作
- (void)loadPlugin {
    if (!_plugins) {
        _plugins = [NSMutableDictionary dictionary];
    }
    NSArray *plugins = objc_getAssociatedObject([self class], kPluginClassMaps);
    [plugins enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        YYSocialPlugin *plugin = [[NSClassFromString(obj) alloc]init];
        [_plugins setValue:plugin forKey:[kPluginPrefix stringByAppendingString:@(plugin.type).stringValue]];
        [plugin loadPlugin];
    }];
    objc_setAssociatedObject([self class], kPluginClassMaps, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)supportPlugins {
    NSMutableArray *supportPlugins = [NSMutableArray arrayWithArray:_plugins.allValues];
    if (!self.showUnsupportPlugin) {
        for (NSInteger i = supportPlugins.count - 1; i >= 0; --i) {
            YYSocialPlugin *plugin = [supportPlugins objectAtIndex:i];
            if (!plugin.isPluginSupport) {
                [supportPlugins removeObjectAtIndex:i];
            }
        }
    }
    return supportPlugins;
}

- (BOOL)shareSNSData : (YYSocialData*)shareData onResponse : (YYSocialDataShareResponse)response
{
    NSString *pluginIdentifier = [kPluginPrefix stringByAppendingString:@(shareData.shareType).stringValue];
    YYSocialPlugin *plugin = [_plugins valueForKey:pluginIdentifier];
    if (plugin) {
        [plugin shareWithData:shareData onResponse:response];
    }else{
        YYSocialResponse *shareResponse = [[YYSocialResponse alloc]init];
        shareResponse.errorCode = YYSocialResponseCodeFail;
        shareResponse.errorStr = @"plugin is not found";
        if (response) {
            response(shareResponse);
        }
    }
    return plugin != nil;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    __block BOOL result = NO;
    [_plugins enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        YYSocialPlugin *plugin = obj;
        result = [plugin handleOpenURL:url] || result;
    }];
    return result;
}
@end
