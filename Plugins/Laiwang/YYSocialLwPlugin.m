//
//  YYSocialLwPlugin.m
//  YYShareModule
//
//  Created by codecooker on 15/7/8.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYSocialLwPlugin.h"
#import "LWApiSDK.h"
#import "YYSocialResponse.h"

@interface YYSocialLwPlugin ()<LWApiSDKDelegate>

@end

@implementation YYSocialLwPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadDefaultOptions];
    }
    return self;
}

- (void)loadDefaultOptions {
    self.type = YYSocialDataTypeLaiwang;
}

#pragma mark -register

- (void)registerPluginWithAppKey:(NSString *)appKey appSecretKey:(NSString *)appSecretKey appDes:(NSString *)appDes {
    [LWApiSDK registerApp:appKey secret:appSecretKey description:appDes];
}


- (void)shareWithData:(YYSocialData *)socialData onResponse:(YYSocialDataShareResponse)response
{
    LWApiMessage *message = nil;
    if (socialData.shareUrl.length) {
        LWApiNewsObject *mediaObject = [LWApiNewsObject object];
        mediaObject.title = socialData.shareTitle;
        mediaObject.description = socialData.shareContent;
        if (socialData.shareImage) {
            mediaObject.thumbImageData = socialData.shareImage;
            NSData* imageData = UIImagePNGRepresentation(socialData.shareImage);
            if (imageData.length >= 32 * 1024) {
                mediaObject.thumbImageData = [UIImage imageNamed:self.defaultImage];
            }
        }else if (socialData.shareImageUrl){
            mediaObject.thumbImageURL = socialData.shareImageUrl;
        }
        mediaObject.detailURL = [socialData.shareUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        message = [LWApiMessage messageWithMedia:mediaObject scene:LWApiSceneFeed];
        if (socialData.shareSubType == YYSocialDataSubTypeTimeLine) {
            message = [LWApiMessage messageWithMedia:mediaObject scene:LWApiSceneSession];
        }
    }else{
        LWApiImageObject* imageObject = [LWApiImageObject object];
        if (socialData.shareImage) {
            imageObject.imageData = socialData.shareImage;
        }else if (socialData.shareImageUrl.length){
            imageObject.imageURL = socialData.shareImageUrl;
        }
        message = [LWApiMessage messageWithImage:imageObject scene:LWApiSceneFeed];
        if (socialData.shareSubType == YYSocialDataSubTypeTimeLine) {
            message = [LWApiMessage messageWithImage:imageObject scene:LWApiSceneSession];
        }
    }
    [LWApiSDK sendRequest:[LWApiSendMessageRequest requestWithMessage:message]];
}

- (void)didReceiveLaiwangRequest:(LWApiBaseRequest*)request
{
    
}

- (void)didReceiveLaiwangResponse:(LWApiBaseResponse*)response
{
    YYSocialResponse* socialResponse = [[YYSocialResponse alloc]init];
    socialResponse.platformType = YYSocialDataTypeLaiwang;
    if (response.errorCode == 0) {
        socialResponse.errorCode = YYSocialResponseCodeSuccess;
        socialResponse.errorStr  = @"分享成功";
    }else if (-1 == response.errorCode){
        socialResponse.errorCode = YYSocialResponseCodeCancel;
        socialResponse.errorStr  = @"取消分享操作";
    }else{
        socialResponse.errorCode = YYSocialResponseCodeFail;
        socialResponse.errorStr  = @"分享失败";
    }
    self.response = socialResponse;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [LWApiSDK handleOpenURL:url delegate:self];
}

#pragma mark -isSupport

- (BOOL)isPluginSupport {
    return [LWApiSDK isLWAppInstalled];
}


@end
