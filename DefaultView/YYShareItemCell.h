//
//  YYShareItemView.h
//  Hermes
//
//  Created by 吕 鹏伟 on 14-5-6.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "TBLotteryUIKit.h"

@interface YYShareItemCell : CPGridViewCell{
    UIView* _iconBg;
}

@property (nonatomic,strong) UILabel     * title;
@property (nonatomic,strong) UIImageView * shareIcon;

@end
