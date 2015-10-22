//
//  YYSocialQRPlugin.m
//  Pods
//
//  Created by codecooker on 15/7/8.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYSocialQRPlugin.h"
#import "YYSocialResponse.h"
#import "CCShareQrCodeView.h"


@implementation YYSocialQRPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = YYSocialDataTypeQR;
    }
    return self;
}

- (void)shareWithData:(YYSocialData *)socialData onResponse:(YYSocialDataShareResponse)response {
    [super shareWithData:socialData onResponse:response];
    if (socialData.shareUrl.length) {
        [CCShareQrCodeView showInView:[UIApplication sharedApplication].keyWindow withURL:[NSURL URLWithString:socialData.shareUrl]];
    }else{
        YYSocialResponse* socialResponse = [[YYSocialResponse alloc]init];
        socialResponse.errorCode         = YYSocialResponseCodeFail;
        socialResponse.errorStr          = @"不支持二维码分享";
        self.response                    = socialResponse;
    }
}

@end
