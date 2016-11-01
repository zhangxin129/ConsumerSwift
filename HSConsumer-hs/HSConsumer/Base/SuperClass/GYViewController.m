//
//  GYViewController.m
//  HSConsumer
//
//  Created by kuser on 15/10/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYViewController.h"
#import "UIView+Extension.h"

@interface GYViewController ()

@property (nonatomic, strong) UILabel* netLabel;

@end

@implementation GYViewController

#pragma mark - system life
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogDebug(@"\n---------Load Controller: %@", [self class]);
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogDebug(@"\n---------Appear Controller: %@", [self class]);
}

- (void)dealloc
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"\n---------dealloc Controller: %@", [self class]);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setExclusiveTouchForButtons:self.view];
}

#pragma - mark public method
- (void)showNoNetworkView
{
    self.netLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.netLabel.userInteractionEnabled = YES;
    self.netLabel.backgroundColor = [UIColor clearColor];

    UITapGestureRecognizer* reloadTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadNetworkData)];
    [self.netLabel addGestureRecognizer:reloadTap];
    [self.view addSubview:self.netLabel];

    UIImageView* imageView = [[UIImageView alloc] init];
    UIImage* image = [UIImage imageNamed:@"gycommon_no_net"];
    imageView.image = image;
    imageView.size = CGSizeMake(image.size.width * 0.3, image.size.height * 0.3);
    imageView.x = (kScreenWidth - imageView.size.width) * 0.5;
    imageView.y = 180;
    [self.netLabel addSubview:imageView];

    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x - 30, imageView.frame.origin.y + imageView.frame.size.height, imageView.frame.size.width + 60, 15)];
    titleLabel.text = kLocalized(@"GYHS_Base_network_unconnection");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = kCorlorFromRGBA(167, 167, 167, 1);
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.netLabel addSubview:titleLabel];

    UILabel* descriptLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) * 0.5, titleLabel.frame.origin.y + titleLabel.frame.size.height + 9, 200, 12)];
    descriptLabel.text = kLocalized(@"GYHS_Base_please_check_network_click_retry");
    descriptLabel.textAlignment = NSTextAlignmentCenter;
    descriptLabel.textColor = kCorlorFromRGBA(167, 167, 167, 1);
    descriptLabel.font = [UIFont systemFontOfSize:12];
    [self.netLabel addSubview:descriptLabel];

    [self.view addSubview:self.netLabel];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)reloadNetworkData
{
    DDLogDebug(@"%s", __FUNCTION__);
}

- (void)dismissNoNetworkView
{
    [self.netLabel removeFromSuperview];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
}

- (NSArray*)popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;
{
    UIViewController* vc = [self findViewController:className];
    if (vc != nil) {
        return [self.navigationController popToViewController:vc animated:YES];
    }

    return nil;
}

#pragma mark - private method
// 设置按钮只能同时点击一个
- (void)setExclusiveTouchForButtons:(UIView*)myView
{
    for (UIView* v in [myView subviews]) {
        if ([v isKindOfClass:[UIButton class]]) {
            [((UIButton*)v)setExclusiveTouch:YES];
        }
        else if ([v isKindOfClass:[UIView class]]) {
            [self setExclusiveTouchForButtons:v];
        }
    }
}

// 寻找Navigation中的某个viewcontroler对象
- (UIViewController*)findViewController:(NSString*)className
{
    NSArray* vcArray = self.navigationController.viewControllers;
    for (UIViewController* vc in vcArray) {
        if ([vc isKindOfClass:NSClassFromString(className)]) {
            return vc;
        }
    }

    DDLogDebug(@"The Controller:%@ is not find.", className);
    return nil;
}

- (void)hidenKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
