//
//  YYSocialCopyPlugin.m
//  Pods
//
//  Created by codecooker on 15/7/8.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYSocialCopyPlugin.h"
#import "YYSocialResponse.h"

@implementation YYSocialCopyPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = YYSocialDataTypeCopy;
    }
    return self;
}

- (void)shareWithData:(YYSocialData *)socialData onResponse:(YYSocialDataShareResponse)response
{
    [super shareWithData:socialData onResponse:response];
    YYSocialResponseErrorCode errorCode = YYSocialResponseCodeSuccess;
    NSString* errorDes = @"复制成功";
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if (socialData.shareUrl.length) {
        pasteboard.URL    = [NSURL URLWithString:socialData.shareUrl];
    }else if (socialData.shareImage){
        pasteboard.image  = socialData.shareImage;
    }else if (socialData.shareContent.length){
        pasteboard.string = socialData.shareContent;
    }else{
        errorCode = YYSocialResponseCodeFail;
        errorDes  = @"不支持复制";
    }
    YYSocialResponse* socialResponse = [[YYSocialResponse alloc]init];
    socialResponse.errorCode = errorCode;
    socialResponse.errorStr  = errorDes;
    self.response = socialResponse;
}

@end
