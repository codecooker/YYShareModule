//
//  YYSocialMailPlugin.m
//  Pods
//
//  Created by codecooker on 15/7/8.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYSocialMailPlugin.h"
#import <MessageUI/MessageUI.h>
#import "YYSocialResponse.h"

@interface YYSocialMailPlugin()<MFMailComposeViewControllerDelegate>

@end

@implementation YYSocialMailPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = YYSocialDataTypeEmail;
    }
    return self;
}

- (void)shareWithData:(YYSocialData *)socialData onResponse:(YYSocialDataShareResponse)response {
    [super shareWithData:socialData onResponse:response];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
        [mailController setSubject:socialData.shareTitle];
        mailController.mailComposeDelegate = self;
        NSString* content = @"";
        if (socialData.shareContent.length) {
            content = [content stringByAppendingString:socialData.shareContent];
        }
        if (socialData.shareImage) {
            [mailController addAttachmentData:UIImageJPEGRepresentation(socialData.shareImage, 1.0f) mimeType:@"JPEG" fileName:@"image.jpg"];
        }else if(socialData.shareImageUrl.length){
            content = [content stringByAppendingFormat:@"<img src=%@",socialData.shareImageUrl];
        }
        if (socialData.shareUrl.length) {
            content = [content stringByAppendingString:[socialData.shareUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        [mailController setMessageBody:content isHTML:YES];
        NSLog(@"%@",[UIApplication sharedApplication].keyWindow.rootViewController);
        if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
            [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:mailController animated:YES completion:nil];
        }else{
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:mailController animated:YES completion:nil];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    YYSocialResponse* socialResponse = [[YYSocialResponse alloc]init];
    socialResponse.platformType = YYSocialDataTypeEmail;
    if (result == MFMailComposeResultSent) {
        socialResponse.errorCode = YYSocialResponseCodeSuccess;
        socialResponse.errorStr  = @"分享成功";
    }else if (MFMailComposeResultCancelled == result || MFMailComposeResultSaved == result){
        socialResponse.errorCode = YYSocialResponseCodeCancel;
        socialResponse.errorStr  = @"取消分享操作";
    }else{
        socialResponse.errorCode = YYSocialResponseCodeFail;
        socialResponse.errorStr  = @"分享失败";
    }
    self.response = socialResponse;
}

#pragma mark share plugin config

- (BOOL)isPluginSupport {
    return [MFMailComposeViewController canSendMail];
}

@end
