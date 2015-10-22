//
//  YYSocialResponse.h
//  YYUIKit
//
//  Created by Powell.lui on 12/1/13.
//  Copyright (c) 2013 Powell.lui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYSocialData.h"

#ifndef __YYSocialDataEngineBlock__

@class YYSocialResponse;

typedef void(^YYSocialDataShareResponse)(YYSocialResponse* response);

#endif

@interface YYSocialResponse : NSObject

typedef NS_ENUM(NSInteger, YYSocialResponseErrorCode){
    YYSocialResponseCodeSuccess,
    YYSocialResponseCodeCancel,
    YYSocialResponseCodeFail,
    YYSocialResponseCodeAuthorizeFail,
    YYSocialResponseCodeAuthorizeSuccess,
    YYSocialResponseCodePrepare                     //正在准备数据
};

//!错误码
@property (nonatomic,assign) YYSocialResponseErrorCode errorCode;

//!错误描述
@property (nonatomic,strong) NSString* errorStr;

//!结果描述
@property (nonatomic,strong) NSString* responseStr;

//!平台类型
@property (nonatomic,assign) YYSocialDataType platformType;


@end
