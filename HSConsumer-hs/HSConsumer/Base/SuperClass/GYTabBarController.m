//
//  GYTabBarController.m
//  HSConsumer
//
//  Created by kuser on 15/10/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYTabBarController.h"
#import "GYSurroundVisitController.h"
#import "GYEasybuyMainViewController.h"
#import "GYHSAccountViewController.h"
#import "GYHDMessageMainViewController.h"
#import "GYHSLoginViewController.h"
#import "GYHSLoginManager.h"
#import "GYAlertView.h"
#import "GYHDNavigationController.h"
#import "GYHSMainViewController.h"
#import "GYHEVisitMainViewController.h"
#import "GYHEEasyBuyMainViewController.h"

@interface GYTabBarController ()

@property (nonatomic, strong) NSMutableArray* navigationControllAry;

@end

@implementation GYTabBarController

- (instancetype)init
{
    if (self = [super init]) {
        self.navigationControllAry = [NSMutableArray array];

        GYHDMessageMainViewController* msgVC = kLoadVcFromClassStringName(NSStringFromClass([GYHDMessageMainViewController class]));
        msgVC.tabBarItem.tag = 0;
        msgVC.tabBarItem.image = [kLoadPng(@"gycommon_tab_message_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        msgVC.tabBarItem.selectedImage = [kLoadPng(@"gycommon_tab_message_click") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        msgVC.tabBarItem.title = kLocalized(@"GYHS_Base_tab_title_message");
        GYHDNavigationController* nav = [[GYHDNavigationController alloc] initWithRootViewController:msgVC];
        [self addChildViewController:nav];
        [self.navigationControllAry addObject:nav];

        //周边逛　navigation
        GYHEVisitMainViewController* visitVC = [[GYHEVisitMainViewController alloc] init];
        [self addChildViewController:visitVC title:kLocalized(@"GYHS_Base_tab_title_around") finishedSelectedImageName:@"gycommon_tab_around_click2" finishedUnselectedImage:@"gycommon_tab_around_normal" tag:1];

        //轻松购 Navigation
        GYHEEasyBuyMainViewController *easyBuyVc = [[GYHEEasyBuyMainViewController alloc] init];
        [self addChildViewController:easyBuyVc title:kLocalized(@"GYHS_Base_tab_title_easybuy") finishedSelectedImageName:@"gycommon_tab_easybuy_click2" finishedUnselectedImage:@"gycommon_tab_easybuy_normal" tag:2];

        //我的互生 Navigation
        GYHSMainViewController* perMainVC = [[GYHSMainViewController alloc] init];
        [self addChildViewController:perMainVC title:kLocalized(@"GYHS_Base_tab_my_HS") finishedSelectedImageName:@"gycommon_tab_mine_click2" finishedUnselectedImage:@"gycommon_tab_mine_normal" tag:3];
        [self.tabBar setTranslucent:YES];

        //字体颜色与导航条相同
        self.tabBar.tintColor = kNavigationBarColor;
        self.selectedIndex = 1;
        [self tabBar:self.tabBar didSelectItem:self.tabBar.items[self.selectedIndex]];
    }

    return self;
}

/**
 *  创建TabBarController子视图方法
 */
- (void)addChildViewController:(UIViewController*)childController title:(NSString*)title finishedSelectedImageName:(NSString*)finishedSelectedImageName finishedUnselectedImage:(NSString*)finishedUnselectedImage tag:(int)tag
{

    childController.title = title;
    childController.tabBarItem.tag = tag;
    childController.tabBarItem.image = [kLoadPng(finishedUnselectedImage) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [kLoadPng(finishedSelectedImageName) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    childController.tabBarItem.title = title;

    // 包装导航控制器
    GYNavigationController* nav = [[GYNavigationController alloc] initWithRootViewController:childController];

    [self addChildViewController:nav];
    [self.navigationControllAry addObject:nav];
}

/**
 *    点击我的互生未登录进入登录界面
 *
 *    @param tabBar tabBar对象
 *    @param item   tabBarItem对象
 */
- (void)tabBar:(UITabBar*)tabBar didSelectItem:(UITabBarItem*)item
{
    UINavigationController* nav = nil;
    if (item.tag < [self.navigationControllAry count]) {
        nav = self.navigationControllAry[item.tag];
    }

    if (nav != nil) {
        if (item.tag != 3) {
            if (item.tag != 0) {
                NSDictionary *dic = @{
                                      NSForegroundColorAttributeName:UIColorFromRGB(0xfb7d00)//文字颜色
                                      };
                [item setTitleTextAttributes:dic forState:UIControlStateHighlighted];
            }
            [nav popToRootViewControllerAnimated:YES];
            
        }
        else {
            NSArray* vcAry = nav.viewControllers;
            id hsMainVC = vcAry.firstObject;
            
            NSDictionary *dic = @{
                            NSForegroundColorAttributeName:UIColorFromRGB(0x1d7dd6)//文字颜色
                                  };
             [item setTitleTextAttributes:dic forState:UIControlStateHighlighted];
            
            if ([hsMainVC isKindOfClass:[GYHSMainViewController class]]) {
                GYHSMainViewController *mainVC = (GYHSMainViewController *)hsMainVC;
                [mainVC showMainView];
            }
        }
    }
}

@end
