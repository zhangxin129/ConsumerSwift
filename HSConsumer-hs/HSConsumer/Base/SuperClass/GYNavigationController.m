//
//  GYNavigationController.m
//  HSConsumer
//
//  Created by apple on 14-10-28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYNavigationController.h"
#import "UIButton+GYExtension.h"
#import "GYTabBarController.h"

#import "GYHDUserSetingViewController.h"
#import "GYAppDelegate.h"
#import "CALayer+Transition.h"
#import "GYHSTools.h"

#define APPDELEGATE ((GYAppDelegate*)[UIApplication sharedApplication].delegate)

@interface GYNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIViewController* showingVC;
@end

@implementation GYNavigationController

+ (void)initialize
{

    [super initialize];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     kNavigationTitleColor, NSForegroundColorAttributeName,
                                                 kNavigationTitleColor, NSBackgroundColorAttributeName,
                                                 [UIFont systemFontOfSize:19.0f], NSFontAttributeName, nil];

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setBackgroundColor:kClearColor];
    [[UINavigationBar appearance] setBarTintColor:kNavigationBarColor];
}

- (instancetype)initWithRootViewController:(UIViewController*)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        [self.navigationBar setTranslucent:NO];
        self.delegate = self;
    }

    return self;
}

- (void)popAction
{
    [GYGIFHUD dismiss];
    [self popViewControllerAnimated:YES];
    UIViewController* vc = self.viewControllers.lastObject;

    NSString* className = NSStringFromClass(self.viewControllers.lastObject.class);
    if ([className hasPrefix:@"GYHS"]) {
        vc.navigationController.navigationBar.barTintColor = kotherPayBtnCorlor;
        NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
        attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        [vc.navigationController.navigationBar setTitleTextAttributes:attDict];
    }
    else if ([className hasPrefix:@"GYHD"]) {
        vc.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
        attDict[NSForegroundColorAttributeName] = kNavigationBarColor;
        [vc.navigationController.navigationBar setTitleTextAttributes:attDict];
    }
    else {
        vc.navigationController.navigationBar.barTintColor = kNavigationBarColor;
        NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
        attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        [vc.navigationController.navigationBar setTitleTextAttributes:attDict];
    }
}

- (UIBarButtonItem*)createBackButtonWithImage:(NSString*)image
{
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if (viewController == nil) {
        DDLogDebug(@"The viewController is nil.");
        return;
    }

    //此处判断，防止无网络的时候推出页面，没有数据。
    if (!globalData.isOnNet && self.viewControllers.count > 1) {
        [GYUtils showToast:kLocalized(@"GYHS_Base_network_unconnection")];
        return;
    }

    [super pushViewController:viewController animated:animated];

    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1) {

        NSString* className = NSStringFromClass([viewController class]);
        if ([className hasPrefix:@"GYHS"]) {
            viewController.navigationController.navigationBar.barTintColor = kotherPayBtnCorlor;
            NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
            attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
            [viewController.navigationController.navigationBar setTitleTextAttributes:attDict];
            viewController.navigationItem.leftBarButtonItem = [self createBackButtonWithImage:@"gycommon_nav_back"];
        }
        else if ([className hasPrefix:@"GYHD"]) {
            viewController.navigationController.navigationBar.barTintColor = [UIColor redColor];
            NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
            attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
            [viewController.navigationController.navigationBar setTitleTextAttributes:attDict];
            viewController.navigationItem.leftBarButtonItem = [self createBackButtonWithImage:@"gycommon_nav_back"];
        }
        else {
            viewController.navigationController.navigationBar.barTintColor = kNavigationBarColor;
            NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
            attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
            [viewController.navigationController.navigationBar setTitleTextAttributes:attDict];
            viewController.navigationItem.leftBarButtonItem = [self createBackButtonWithImage:@"gycommon_nav_back"];
        }
    }
}





@end
