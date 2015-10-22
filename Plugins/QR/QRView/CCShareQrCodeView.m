//
//  TBShareQrCodeView.m
//  Taobao2013
//
//  Created by codecooker on 9/5/13.
//  Copyright (c) 2013 codecooker.com. All rights reserved.
//

#import "CCShareQrCodeView.h"
#import "QRCodeGenerator.h"

#define QR_CODE_IMAGE_SIZE 176
#define QR_CODE_STAND_BORDER (SCREEN_WIDTH - QR_CODE_BG_WIDTH)/2
#define QR_CODE_BG_WIDTH   280
#define QR_CODE_BG_HEIGHT  320
#define DEFAULT_TITLE @"二维码"
#define DEFAULT_DESCRIPTION @"用手机扫瞄二维码"
#define SCREEN_WIDTH (CGRectGetWidth([UIScreen mainScreen].bounds))
#define SCREEN_HEIGHT (CGRectGetHeight([UIScreen mainScreen].bounds))

@interface CCShareQrCodeView ()

@property (nonatomic,strong) UIView* maskView;
@property (nonatomic,strong) UIView* bgImgView;

// head view
@property (nonatomic, strong) UIView*   headView;
@property (nonatomic, strong) UIImageView* headBgView;
@property (nonatomic, strong) UILabel* titleLabel;

@property (nonatomic, strong) UIImageView* sepLineView;  // 分界线

// QrCode view
@property(nonatomic,retain) UIImageView *qrCodeImageView;
@property(nonatomic,retain) UIImageView *headPicImageView;
@property(nonatomic,retain) UILabel *descriptionLabel;

@property (nonatomic, strong) UIButton* closeBtn;

@end

@implementation CCShareQrCodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Init

+ (CCShareQrCodeView *)shareInstance {
    static CCShareQrCodeView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    });
    
    return shareInstance;
}

-(void)setupView {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self initBgView];
    [self initHeadView];
    [self initQrCodeView];
    [self initCloseButton];
}

-(void)initBgView {
    
    self.bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(QR_CODE_STAND_BORDER,(CGRectGetHeight(self.frame) - QR_CODE_BG_HEIGHT)/2 , QR_CODE_BG_WIDTH, QR_CODE_BG_HEIGHT)];
    
    self.bgImgView.backgroundColor = [UIColor colorWithRed:0xf4 green:0xf4 blue:0xf4 alpha:1.0];
    self.bgImgView.layer.cornerRadius = 6;
    self.bgImgView.layer.masksToBounds = YES;
    
    [self addSubview:self.bgImgView];
}

-(void)initHeadView {
    self.headBgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bgImgView.frame), CGRectGetMinY(self.bgImgView.frame), QR_CODE_BG_WIDTH, 44.0)];
    [self addSubview:self.headBgView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 14, 180, 18)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = @"扫码分享";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.headBgView addSubview:self.titleLabel];
    
    self.sepLineView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.headBgView.frame), CGRectGetMinY(self.headBgView.frame) + self.headBgView.frame.size.height-1, QR_CODE_BG_WIDTH, 1.0)];
    self.sepLineView.image = [[UIImage imageNamed:@"share_line"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
//    self.sepLineView.backgroundColor = [UIColor colorWithRed:0xdd green:0xdd blue:0xdd alpha:1.0];
    [self addSubview:self.sepLineView];
}

-(void)initQrCodeView {
    self.qrCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - QR_CODE_IMAGE_SIZE)/2, self.headBgView.frame.origin.y + self.headBgView.frame.size.height + 32, QR_CODE_IMAGE_SIZE, QR_CODE_IMAGE_SIZE)];
    [self addSubview:self.qrCodeImageView];
    
    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.qrCodeImageView.frame), CGRectGetMinY(self.qrCodeImageView.frame) + self.qrCodeImageView.frame.size.height + 20, QR_CODE_IMAGE_SIZE, 20)];
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    self.descriptionLabel.text = @"邀请好友扫一扫分享给TA";
    self.descriptionLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.descriptionLabel];
    
    int headSize = 40;
    self.headPicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.qrCodeImageView.frame) + (CGRectGetWidth(self.qrCodeImageView.frame) - headSize)/2, CGRectGetMinY(self.qrCodeImageView.frame) + (CGRectGetHeight(self.qrCodeImageView.frame) - headSize)/2, headSize, headSize)];
    
    self.headPicImageView.hidden = YES;
    [self addSubview:self.headPicImageView];
}

-(void)initCloseButton {
    self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(20 + QR_CODE_STAND_BORDER), CGRectGetMinY(self.bgImgView.frame) - 12, 28.0, 28.0)];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.closeBtn];
}

-(void)hide {
    [self removeFromSuperview];
}


+(void)showInView:(UIView *)view withURL:(NSURL *)url {
    if (view && url) {
        CCShareQrCodeView* qrCodeView = [CCShareQrCodeView shareInstance];
        [qrCodeView setDataWithURL:url];
        
        [view addSubview:qrCodeView];
    }
}

+(void)showInView:(UIView *)view withURL:(NSURL *)url title:(NSString *)title description: (NSString*)description headPic:(UIImage *)headPic orHeadPicURL:(NSURL *)picUrl {
    if (view && url) {
        CCShareQrCodeView* qrCodeView = [CCShareQrCodeView shareInstance];
        [qrCodeView setDataWithURL:url title:title description:description headPic:headPic orHeadPicURL:picUrl];
        
        [view addSubview:qrCodeView];
    }
}

-(void)setDataWithURL: (NSURL*)url {
    NSString* urlStr = [url absoluteString];
    if (urlStr.length > 0) {
        self.qrCodeImageView.image = [QRCodeGenerator qrImageForString:urlStr imageSize:QR_CODE_IMAGE_SIZE*2];
    }
}

-(void)setDataWithURL:(NSURL*)url title:(NSString*)title description: (NSString*)description headPic: (UIImage*)headPic orHeadPicURL:(NSURL*)picUrl {
    NSString* urlStr = [url absoluteString];
    if (urlStr.length > 0) {
        self.qrCodeImageView.image = [QRCodeGenerator qrImageForString:urlStr imageSize:QR_CODE_IMAGE_SIZE*2];
    }
    if (title.length > 0) {
        self.titleLabel.text = title;
    }
    if (description.length > 0) {
        self.descriptionLabel.text = description;
    }
    
    self.headPicImageView.hidden = YES;
    if (headPic) {
        self.headPicImageView.hidden = NO;
        self.headPicImageView.image = headPic;
    }else if (picUrl) {
        self.headPicImageView.hidden = NO;
    }
}

// url特殊字符处理
+ (NSString*)urlEscapedWithUrlString:(NSString*)urlString {
    NSString *escapedUrlString = (__bridge_transfer NSString * )
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef)urlString,
                                            NULL,
                                            (CFStringRef)@"!*'();@+$,%[]",
                                            kCFStringEncodingUTF8);
    return escapedUrlString;
}
@end
