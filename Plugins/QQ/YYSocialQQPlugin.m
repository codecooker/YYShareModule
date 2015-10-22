//
//  YYSocialQQPlugin.m
//  Pods
//
//  Created by codecooker on 15/7/8.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYSocialQQPlugin.h"
#import "TencentOAuth.h"
#import "QQApi.h"
#import "QQApiInterface.h"
#import "QQApiInterfaceObject.h"
#import "YYSocialResponse.h"

@interface YYSocialQQPlugin ()<QQApiInterfaceDelegate,TencentSessionDelegate>

@end

@implementation YYSocialQQPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = YYSocialDataTypeQQ;
    }
    return self;
}

#pragma mark -register

- (void)registerPluginWithAppKey:(NSString *)appKey appSecretKey:(NSString *)appSecretKey appDes:(NSString *)appDes {
    __unused BOOL result = [[TencentOAuth alloc] initWithAppId:appKey andDelegate:self];
}

- (void)shareWithData:(YYSocialData *)socialData onResponse:(YYSocialDataShareResponse)response {
    [super shareWithData:socialData onResponse:response];
    QQApiSendResultCode code = EQQAPISENDSUCESS;
    QQBaseReq* request = [self QQRequstWithSocialData:socialData];
    if (socialData.shareSubType == YYSocialDataSubTypeChat) {
        code = [QQApiInterface sendReq:request];
    }else{
        code = [QQApiInterface SendReqToQZone:request];
    }
    if (code != EQQAPISENDSUCESS && code != EQQAPIAPPSHAREASYNC) {
        YYSocialResponse* socialResponse = [[YYSocialResponse alloc]init];
        socialResponse.errorCode = YYSocialResponseCodeFail;
        socialResponse.errorStr  = @"暂不支持此类分享";
        self.response = socialResponse;
    }
}


- (QQBaseReq*)QQRequstWithSocialData : (YYSocialData*)socialData
{
    QQBaseReq* request = nil;
    if (socialData.shareUrl.length) {
        NSString *previewImageUrl = self.defaultImage;
        NSURL *imageUrl = [NSURL fileURLWithPath:previewImageUrl];
        if (socialData.shareImageUrl.length) {
            imageUrl = [NSURL URLWithString:socialData.shareImageUrl];
        }
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:socialData.shareUrl]
                                    title: socialData.shareTitle
                                    description:socialData.shareContent
                                    previewImageURL:imageUrl];
        request = [SendMessageToQQReq reqWithContent:newsObj];
    }else if(nil != socialData.shareImage){
        NSData* imageData = UIImageJPEGRepresentation(socialData.shareImage, 1.0f);
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imageData
                                                   previewImageData:imageData
                                                              title:socialData.shareTitle
                                                        description:socialData.shareContent];
        request = [SendMessageToQQReq reqWithContent:imgObj];
    }else if(socialData.shareImageUrl.length){
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:socialData.shareImageUrl]];
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imageData
                                                   previewImageData:imageData
                                                              title:socialData.shareTitle
                                                        description:socialData.shareContent];
        request = [SendMessageToQQReq reqWithContent:imgObj];
    }else{
        QQApiTextObject *txtObj = [QQApiTextObject objectWithText:socialData.shareContent];
        request = [SendMessageToQQReq reqWithContent:txtObj];
    }
    return request;
}

-(void) onResp:(QQBaseResp*)resp
{
    QQBaseResp* qqResp = (QQBaseResp*)resp;
    YYSocialResponse* socialResponse = [[YYSocialResponse alloc]init];
    socialResponse.platformType = YYSocialDataTypeWeixin;
    if (qqResp.errorDescription.length == 0) {
        socialResponse.errorCode = YYSocialResponseCodeSuccess;
        socialResponse.errorStr = @"分享成功";
    }else{
        socialResponse.errorCode = YYSocialResponseCodeFail;
        socialResponse.errorStr = @"分享失败";
    }
    self.response = socialResponse;
}

- (void)onReq:(QQBaseReq *)req {
    
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [QQApiInterface handleOpenURL:url delegate:self];
}

#pragma mark -isSupport

- (BOOL)isPluginSupport {
    if (![QQApi isQQInstalled] || ![QQApi isQQSupportApi]) {
        return NO;
    }
    return YES;
}


#pragma mark -hide tencent warning

- (void)tencentDidNotNetWork {
    
}

- (void)tencentDidLogin {
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

@end
