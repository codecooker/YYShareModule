//
//  YYShareItemView.m
//  Hermes
//
//  Created by 吕 鹏伟 on 14-5-6.
//  Copyright (c) 2015年 codecooker.com. All rights reserved.
//

#import "YYShareItemCell.h"

@implementation YYShareItemCell

@synthesize title     = _title;
@synthesize shareIcon = _shareIcon;

- (id)initWithReuseIdentifier:(NSString *)identifier
{
    self = [super initWithReuseIdentifier:identifier];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews
{
    _title = [UILabel labelWithTextColor:[UIColor blackColor] shadowColor:[UIColor clearColor] font:[UIFont systemFontOfSize:12.0f]];
    [self.contentView addSubview:_title];
    _shareIcon = [[UIImageView alloc]init];
    _iconBg = [[UIView alloc]init];
    [_iconBg addSubview:_shareIcon];
    [self.contentView addSubview:_iconBg];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize shareIconBgSize = CGSizeMake(_shareIcon.image.size.width + 15.0f, _shareIcon.image.size.height + 15.0f);
    CGSize titleSize = [_title sizeThatFits:CGSizeZero];
    CGFloat orginY = CGRectGetHeight(self.frame) - shareIconBgSize.height - titleSize.height - 10.0f;
    _shareIcon.frame = CGRectMake((shareIconBgSize.width - _shareIcon.image.size.width) / 2, (shareIconBgSize.height - _shareIcon.image.size.height) / 2, _shareIcon.image.size.width, _shareIcon.image.size.height);
    _iconBg.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) - shareIconBgSize.width) / 2, orginY, shareIconBgSize.width, shareIconBgSize.height);
    _title.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) - titleSize.width) / 2, CGRectGetMaxY(_iconBg.frame) + 5.0f, titleSize.width, titleSize.height);
}

@end
