//
//  YYSocialWxPlugin.m
//  YYShareModule
//
//  Created by codecooker on 15/7/8.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYSocialWxPlugin.h"
#import "WXApi.h"
#import "YYSocialData.h"
#import "YYSocialResponse.h"

@interface YYSocialWxPlugin ()<WXApiDelegate>

@end

@implementation YYSocialWxPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadDefaultOptions];
    }
    return self;
}

- (void)loadDefaultOptions {
    self.type = YYSocialDataTypeWeixin;
}

#pragma mark -register

- (void)registerPluginWithAppKey:(NSString *)appKey appSecretKey:(NSString *)appSecretKey appDes:(NSString *)appDes {
    [WXApi registerApp:self.appKey];
}

- (void)shareWithData : (YYSocialData *)socialData onResponse : (YYSocialDataShareResponse)response {
    [super shareWithData:socialData onResponse:response];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title           = socialData.shareTitle;
    message.description     = socialData.shareContent;
    NSData* imageData       = UIImagePNGRepresentation(socialData.shareImage);
    if (!imageData && socialData.shareImageUrl) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:socialData.shareImageUrl]];
    }
    [message setThumbImage:socialData.shareImage];
    if (imageData.length >= 32 * 1024 || !imageData) {
        [message setThumbImage:[UIImage imageNamed:self.defaultImage]];
    }
    if (socialData.shareUrl.length) {
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl       = [socialData.shareUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        message.mediaObject  = ext;
    }else if(socialData.shareImage){
        WXImageObject* ext  = [WXImageObject object];
        ext.imageData       = UIImagePNGRepresentation(socialData.shareImage);
        message.mediaObject = ext;
    }else{
        WXImageObject* ext  = [WXImageObject object];
        ext.imageData       = [NSData dataWithContentsOfURL:[NSURL URLWithString:socialData.shareImageUrl]];
        message.mediaObject = ext;
    }
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText               = NO;
    req.message             = message;
    req.scene               = WXSceneSession;
    if (socialData.shareSubType == YYSocialDataSubTypeTimeLine) {
        req.scene = WXSceneTimeline;
    }
    [WXApi sendReq:req];
}

-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    YYSocialResponse* socialResponse = [[YYSocialResponse alloc]init];
    socialResponse.platformType = YYSocialDataTypeWeixin;
    if (resp.errCode == WXSuccess) {
        socialResponse.errorCode = YYSocialResponseCodeSuccess;
        socialResponse.errorStr = @"分享成功";
    }else if (WXErrCodeUserCancel == resp.errCode){
        socialResponse.errorCode = YYSocialResponseCodeCancel;
        socialResponse.errorStr = @"取消分享操作";
    }else{
        socialResponse.errorCode = YYSocialResponseCodeFail;
        socialResponse.errorStr = @"分享失败";
    }
    self.response = socialResponse;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark -isSupport

- (BOOL)isPluginSupport {
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        return NO;
    }
    return YES;
}

@end
