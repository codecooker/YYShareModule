//
//  YYShareItemView.h
//  Hermes
//
//  Created by codecooker on 14-5-6.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYUIKit.h"

@interface YYShareItemCell : YYGridViewCell{
    UIView* _iconBg;
}

@property (nonatomic,strong) UILabel     * title;
@property (nonatomic,strong) UIImageView * shareIcon;

@end
