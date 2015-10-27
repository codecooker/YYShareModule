//
//  YYSocialDataEngine+LoadPlugin.h
//  YYShareModule
//
//  Created by codecooker on 15/7/8.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYSocialDataEngine.h"
#import "YYSocialPlugin.h"

@interface YYSocialDataEngine (LoadPlugin)

/*!
 *  @author codecooker
 *
 *  @brief  注册plugin给分享引擎，私有方法，不需要显式调用，系统会自己调用
 *
 *  @param pluginName 各个分享模块行程的plugin，必须继承自YYSocialPlugin
 */

+ (BOOL)registerPlugin : (NSString *)pluginName onPluginLoad : (YYSocialPluginOnLoad)onLoad;

@end
