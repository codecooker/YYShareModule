//
//  YYSocialSinaPlugin.m
//  YYShareModule
//
//  Created by codecooker on 15/7/8.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYSocialSinaPlugin.h"
#import "WeiboSDK.h"
#import "YYSocialResponse.h"

@interface YYSocialSinaPlugin ()<WeiboSDKDelegate>

@end

@implementation YYSocialSinaPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = YYSocialDataTypeSina;
    }
    return self;
}

#pragma mark -register

- (void)registerPluginWithAppKey:(NSString *)appKey appSecretKey:(NSString *)appSecretKey appDes:(NSString *)appDes {
    [WeiboSDK registerApp:appKey];
}

- (void)shareWithData:(YYSocialData *)socialData onResponse:(YYSocialDataShareResponse)response
{
    if ([WeiboSDK isWeiboAppInstalled]) {
        WBMessageObject *message = [WBMessageObject message];
        NSString *textContent = socialData.shareContent;
        textContent = textContent ? textContent : @"";
        NSString* bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        if ([textContent rangeOfString:bundleName].location == NSNotFound) {
            textContent = [NSString stringWithFormat:@"%@ @%@",textContent,bundleName];
        }
        NSString *addLinkTextContent = [textContent copy];
        //todo,链接地址需要填写
        NSString* shortUrl = [socialData.shareUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ?: self.defaultUrl;
        message.text = textContent;
        if (socialData.shareImage) {
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData      = UIImagePNGRepresentation(socialData.shareImage);
            message.text               = addLinkTextContent;
            message.imageObject        = imageObject;
        } else if(socialData.shareImageUrl.length) {
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData      = [NSData dataWithContentsOfURL:[NSURL URLWithString:socialData.shareImageUrl]];
            message.text               = addLinkTextContent;
            message.imageObject        = imageObject;
        }
        if (socialData.shareUrl.length) {
            if (message.imageObject) {
                message.text = [message.text stringByAppendingString:socialData.shareUrl];
            }else{
                if (!socialData.shareImage && !socialData.shareImageUrl.length) {
                    socialData.shareImage = [UIImage imageNamed:self.defaultImage];
                }
                WBWebpageObject *webObject = [WBWebpageObject object];
                webObject.webpageUrl    = shortUrl;
                webObject.thumbnailData = UIImagePNGRepresentation(socialData.shareImage);;
                webObject.objectID      = socialData.shareTitle;
                webObject.title         = socialData.shareTitle;
                webObject.description   = socialData.shareContent;
                message.mediaObject     = webObject;
            }
        }
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:request];
    }
}

- (void)sendAuthorizeSinaWb
{
    WBAuthorizeRequest* request = [WBAuthorizeRequest request];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    request.scope       = @"all";
    request.redirectURI = @"defaultUrl";
    [WeiboSDK sendRequest:request];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    YYSocialResponse* socialResponse = [[YYSocialResponse alloc]init];
    socialResponse.platformType = YYSocialDataTypeSina;
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        socialResponse.errorCode = YYSocialResponseCodeSuccess;
        socialResponse.errorStr  = @"分享成功";
    }else if (WeiboSDKResponseStatusCodeUserCancel == response.statusCode){
        socialResponse.errorCode = YYSocialResponseCodeCancel;
        socialResponse.errorStr  = @"取消分享操作";
    }else{
        socialResponse.errorCode = YYSocialResponseCodeFail;
        socialResponse.errorStr  = @"分享失败";
    }
    self.response = socialResponse;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)isPluginSupport {
    return [WeiboSDK isWeiboAppInstalled];
}

@end
