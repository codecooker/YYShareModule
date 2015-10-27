//
//  YYSocialData.m
//  YYShareModule
//
//  Created by Powell.lui on 12/1/13.
//  Copyright (c) 2013 Powell.lui. All rights reserved.
//

#import "YYSocialData.h"

@implementation YYSocialData

@synthesize shareContent      = _shareContent;
@synthesize shareType         = _shareType;
@synthesize shareSubType      = _shareSubType;
@synthesize shareImage        = _shareImage;
@synthesize responseUrl       = _responseUrl;
@synthesize mediaObject       = _mediaObject;
@synthesize currentController = _currentController;
@synthesize shareImageUrl     = _shareImageUrl;
@synthesize shareUrl          = _shareUrl;
@synthesize shareTitle        = _shareTitle;
@synthesize shareToFriends    = _shareToFriends;


- (void)setShareUrl:(NSString *)shareUrl
{
    _shareUrl      = shareUrl;
}

- (NSString*)shortShareUrl
{
    return _shareUrl;
}

- (NSString*)shareUrl
{
    return [self shortShareUrl];
}

- (void)dealloc
{
}

@end
