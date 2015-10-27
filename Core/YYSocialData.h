//
//  YYSocialData.h
//  YYShareModule
//
//  Created by Powell.lui on 12/1/13.
//  Copyright (c) 2013 Powell.lui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YYSocialDataType.h"

@class YYShareMediaObject;

@interface YYSocialData : NSObject{
    YYSocialDataType _shareType;
    NSString* _shareContent;
    NSString* _responseUrl;
    UIImage* _shareImage;
    YYShareMediaObject* _mediaObject;
    __weak UIViewController* _currentController;
}

@property (nonatomic,strong) NSString                     * shareContent;
@property (nonatomic,strong) NSString                     * shareTitle;
@property (nonatomic,strong) NSString                     * responseUrl;
@property (nonatomic,strong) UIImage                      * shareImage;
@property (nonatomic,assign) YYSocialDataType               shareType;
@property (nonatomic,assign) YYSocialDataSubType            shareSubType;
@property (nonatomic,strong) YYShareMediaObject           * mediaObject;
@property (nonatomic,weak)   UIViewController             * currentController;
@property (nonatomic,strong) NSString* shareImageUrl;
@property (nonatomic,strong) NSString* shareUrl;
@property (nonatomic,strong) NSArray* shareToFriends;
@property (nonatomic,strong) NSArray* supportPlatforms;

@end
