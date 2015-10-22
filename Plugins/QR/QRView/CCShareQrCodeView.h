//
//  TBShareQrCodeView.h
//  Taobao2013
//
//  Created by codecooker on 9/5/13.
//  Copyright (c) 2013 codecooker.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCShareQrCodeView : UIView


+ (void)showInView: (UIView*)view withURL: (NSURL*)url;

+ (void)showInView:(UIView *)view withURL:(NSURL *)url title: (NSString*)title description: (NSString*)description headPic:(UIImage*)headPic orHeadPicURL:(NSURL*)picUrl;

@end
