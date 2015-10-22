//
//  YYSocialMenuViewController.m
//  Hermes
//
//  Created by 吕 鹏伟 on 14-4-25.
//
//

#import "YYSocialMenuViewController.h"
#import "YYSocialDataEngine.h"
#import "YYShareItemCell.h"
#import "YYSocialPlugin.h"

#define kPanelHeight                        (250+50)

@interface YYSocialMenuViewController ()<CPGridViewDataSource,CPGridViewDelegate>{
    YYSocialData* _socialData;
    UIImageView *_panelView;
    CPGridView *_mainView;
    UIButton *_cancelButton;
    UILabel *_titleLabel;
    YYSocialDataShareResponse _socialDataShareResponse;
    NSArray *_pluginInfos;
}

@property (nonatomic,strong) UIView *panelView;

@end

@implementation YYSocialMenuViewController

@synthesize panelView = _panelView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.supportSharedPlatforms = [YYSocialDataEngine shareInstance].supportPlugins;
    }
    return self;
}

- (void)dealloc
{
    _mainView.gridDelegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _panelView                        = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), kPanelHeight)];
    _panelView.image                  = [[UIImage imageNamed:@"sharebg"]stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
    _panelView.userInteractionEnabled = YES;
    _panelView.backgroundColor        = [UIColor clearColor];
    self.view.backgroundColor         = [UIColor clearColor];
    [self.view addSubview:_panelView];
    
    _titleLabel = [UILabel labelWithTextColor:[UIColor blackColor] shadowColor:nil font:[UIFont systemFontOfSize:14.0f]];
    
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.text = @"想告诉谁";
    [_panelView addSubview:_titleLabel];
    [self loadMenuView];
}

- (void)loadMenuView
{
    //默认每行显示4个
    NSInteger colCount     = 4;
    CGSize itemSize        = CGSizeMake(65.0f, 85.0f);
    CGFloat colMargin      = ((CGRectGetWidth(self.view.frame) - 20.0f) - (colCount * itemSize.width)) / (colCount - 1);
    _mainView              = [[CPGridView alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.frame) - 20.0f, 200) andStyle:CPGridViewStyleAuto];
    _mainView.colMargin    = colMargin;
    _mainView.rowMargin    = 10.0f;
    _mainView.gridDelegate = self;
    _mainView.dataSource   = self;
    [_panelView addSubview:_mainView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -gridView 代理和数据源

- (NSDictionary *)pluginInfoWithPlugin : (YYSocialPlugin *)plugin {
    if (!_pluginInfos) {
        _pluginInfos = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"sharePlatform" ofType:@"plist"]];
    }
    __block NSDictionary *pluginInfo = nil;
    [_pluginInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj valueForKey:@"platformType"]integerValue] == plugin.type) {
            pluginInfo = obj;
            *stop = YES;
        }
    }];
    return pluginInfo;
}

- (NSInteger)cellNumOfGridView:(CPGridView *)gridView{
    return self.supportSharedPlatforms.count;
}

- (CPGridViewCell*)GridView:(CPGridView *)gridView itemForIndex:(NSInteger)path
{
    static NSString* cellMark = @"cellMark";
    YYShareItemCell* cell     = [gridView dequeueReusableCellWithIdentifier:cellMark];
    if (!cell) {
        cell = [[YYShareItemCell alloc]initWithReuseIdentifier:cellMark];
    }
    YYSocialPlugin *plugin = [self.supportSharedPlatforms objectAtIndex:path];
    NSDictionary *pluginInfo = [self pluginInfoWithPlugin:plugin];
    cell.shareIcon.image       = [UIImage imageNamed:[pluginInfo valueForKey:@"icon_normal"]];
    cell.title.text            = [pluginInfo valueForKey:@"platformName"];
    return cell;
}

- (NSInteger)gridView:(CPGridView *)gridView didSelectGridAtIndex:(NSInteger)index
{
    YYSocialPlugin *plugin = [self.supportSharedPlatforms objectAtIndex:index];
    _socialData.shareType      = plugin.type;
    [[YYSocialDataEngine shareInstance]shareSNSData:_socialData onResponse:_socialDataShareResponse];
    [self hideShareSocialViewWithAnimation:NO];
    return 0;
}

- (CGSize)gridView:(CPGridView *)gridView itemSizeAtIndex:(NSInteger)index
{
    return CGSizeMake(65.0f, 85.0f);
}

#pragma mark -显示分享菜单

- (void)shareSocialData:(YYSocialData *)data InCtl:(UIViewController *)ctl onResponse:(YYSocialDataShareResponse)response
{
    _socialDataShareResponse = response;
    [ctl.view addSubview:self.view];
    [ctl addChildViewController:self];
    _socialData = data;
    __weak YYSocialMenuViewController* weakSelf = self;
    CGSize gridViewSize = _mainView.contentSize;
    CGSize panelViewSize = CGSizeMake(CGRectGetWidth(self.view.frame), gridViewSize.height + 2 * 10.0f + 40.0f);
    _panelView.frame = CGRectMake(0, CGRectGetMinY(_panelView.frame), panelViewSize.width, panelViewSize.height);
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong YYSocialMenuViewController* sself = weakSelf;
        sself.panelView.center = CGPointMake(sself.panelView.center.x, CGRectGetHeight(sself.view.frame) - CGRectGetHeight(sself.panelView.frame) / 2);

    } completion:nil];
}

- (void)hideShareSocialViewWithAnimation : (BOOL)animation
{
    _socialDataShareResponse = nil;
    __weak YYSocialMenuViewController* weakSelf = self;
    [UIView animateWithDuration:0.3f * animation delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        __strong YYSocialMenuViewController* sself = weakSelf;
        sself.panelView.center = CGPointMake(sself.panelView.center.x, CGRectGetHeight(sself.view.frame) + CGRectGetHeight(sself.panelView.frame) / 2);
    } completion:^(BOOL finished) {
        __strong YYSocialMenuViewController* sself = weakSelf;
        [sself.view removeFromSuperview];
        [sself performSelectorOnMainThread:@selector(removeFromParentViewController) withObject:nil waitUntilDone:NO];
    }];
}

- (void)viewWillLayoutSubviews
{
    CGSize gridViewSize        = _mainView.contentSize;
    _mainView.frame            = CGRectMake((CGRectGetWidth(_panelView.frame) - gridViewSize.width) / 2, 50.0f, gridViewSize.width, gridViewSize.height);
    CGSize titleLabelSize      = [_titleLabel sizeThatFits:CGSizeZero];
    _titleLabel.frame          = CGRectMake(0, 20.0f, CGRectGetWidth(_panelView.frame), titleLabelSize.height);
}

#pragma mark -响应事件

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch* touch = [touches anyObject];
    if (!CGRectContainsPoint(_panelView.frame, [touch locationInView:self.view])) {
        [self hideShareSocialViewWithAnimation:YES];
    }
}

@end
