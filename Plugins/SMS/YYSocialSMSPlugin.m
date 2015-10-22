//
//  YYSocialSMSPlugin.m
//  Pods
//
//  Created by codecooker on 15/7/7.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYSocialSMSPlugin.h"
#import <MessageUI/MessageUI.h>
#import "YYSocialResponse.h"

@interface YYSocialSMSPlugin ()<MFMessageComposeViewControllerDelegate>
@end

@implementation YYSocialSMSPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = YYSocialDataTypeSMS;
    }
    return self;
}

- (void)shareWithData:(YYSocialData *)socialData onResponse:(YYSocialDataShareResponse)response {
    [super shareWithData:socialData onResponse:response];
    NSString *textContent = @"";
    if (socialData.shareContent.length) {
        textContent = [textContent stringByAppendingString:socialData.shareContent];
    }
    if (socialData.shareUrl.length) {
        textContent = [textContent stringByAppendingString:[socialData.shareUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate          = self;
        picker.body                            = textContent;
        picker.recipients                      = socialData.shareToFriends;
        NSLog(@"%@",[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController);
        if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
            [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:picker animated:YES completion:nil];
        }else{
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
        }
    }
}

#pragma mark -MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    YYSocialResponse* socialResponse = [[YYSocialResponse alloc]init];
    socialResponse.platformType      = YYSocialDataTypeSMS;
    if (result == MessageComposeResultSent) {
        socialResponse.errorCode = YYSocialResponseCodeSuccess;
        socialResponse.errorStr  = @"分享成功";
    }else if (MessageComposeResultCancelled == result){
        socialResponse.errorCode = YYSocialResponseCodeCancel;
        socialResponse.errorStr  = @"取消分享操作";
    }else{
        socialResponse.errorCode = YYSocialResponseCodeFail;
        socialResponse.errorStr  = @"分享失败";
    }
    self.response = socialResponse;
}

#pragma mark -share plugin config

- (BOOL)isPluginSupport {
    return [MFMessageComposeViewController canSendText];
}

@end
