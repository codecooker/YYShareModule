//
//  YYSocialDataEngine+LoadPlugin.m
//  Pods
//
//  Created by codecooker on 15/7/8.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYSocialDataEngine+LoadPlugin.h"
#import <objc/runtime.h>
#import "YYSocialPlugin.h"

#define kPluginClassMaps                     "YYSocialPluginMap"
#define kPluginOnLoadHook                    "YYSocialPluginOnLoad"

@implementation YYSocialDataEngine (LoadPlugin)

+ (BOOL)registerPlugin:(NSString *)pluginName onPluginLoad:(YYSocialPluginOnLoad)onLoad{
    Class pluginClass = objc_getClass(pluginName.UTF8String);
    objc_setAssociatedObject(pluginClass, kPluginOnLoadHook, onLoad, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    BOOL registerResult = [pluginClass isKindOfClass:[YYSocialPlugin class]] || YES;
    if (registerResult) {
        NSMutableArray *plugins = objc_getAssociatedObject(self, kPluginClassMaps);
        if (!plugins) {
            plugins = [NSMutableArray array];
        }
        if (![plugins containsObject:pluginName]) {
            [plugins addObject:pluginName];
        }
        objc_setAssociatedObject(self, kPluginClassMaps, plugins, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return NO;
}

@end
