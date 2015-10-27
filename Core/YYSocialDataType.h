//
//  YYSocialDataType.h
//  YYShareModule
//
//  Created by codecooker on 15/7/28.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#ifndef Pods_YYSocialDataType_h
#define Pods_YYSocialDataType_h

typedef NS_ENUM(NSUInteger, YYSocialDataType) {
    YYSocialDataTypeSina = 0x1234,
    YYSocialDataTypeQQ,
    YYSocialDataTypeWeixin,
    YYSocialDataTypeLaiwang,
    YYSocialDataTypeSMS,
    YYSocialDataTypeEmail,
    YYSocialDataTypeCopy,
    YYSocialDataTypeQR,
    YYSocialDataTypeContact,
    YYSocialDataTypeWXWW,
};

typedef NS_ENUM(NSUInteger, YYSocialDataSubType) {
    YYSocialDataSubTypeDefault = 0x4320,                //default is YYSocialDataSubTypeChat
    YYSocialDataSubTypeChat = 0x4321,
    YYSocialDataSubTypeTimeLine,
};

#endif
