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
#import "GYHDMainViewController.h"
#import "GYHSLoginViewController.h"
#import "GYHSLoginManager.h"
#import "GYAlertView.h"
#import "GYHDNavigationController.h"

@implementation GYTabBarController

- (instancetype)init
{
    if (self = [super init]) {
        GYHDMainViewController* msgVC = kLoadVcFromClassStringName(NSStringFromClass([GYHDMainViewController class]));
        msgVC.tabBarItem.tag = 0;
        msgVC.tabBarItem.image = [kLoadPng(@"gycommon_tab_message_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        msgVC.tabBarItem.selectedImage = [kLoadPng(@"gycommon_tab_message_click") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        msgVC.tabBarItem.title = kLocalized(@"GYHS_Base_tab_title_message");
        GYHDNavigationController* nav = [[GYHDNavigationController alloc] initWithRootViewController:msgVC];
        [self addChildViewController:nav];

        //周边逛　navigation
        GYSurroundVisitController* perMainVC = kLoadVcFromClassStringName(NSStringFromClass([GYSurroundVisitController class]));
        
        [self addChildViewController:perMainVC title:kLocalized(@"GYHS_Base_tab_title_around") finishedSelectedImageName:@"gycommon_tab_around_click" finishedUnselectedImage:@"gycommon_tab_around_normal" tag:1];

        //轻松购 Navigation
        //        GYEasyPurchaseMainViewController *easyBuyVC = [[GYEasyPurchaseMainViewController alloc] init];
        GYEasybuyMainViewController* easyBuyVC = [[GYEasybuyMainViewController alloc] init];
        [self addChildViewController:easyBuyVC title:kLocalized(@"GYHS_Base_tab_title_easybuy") finishedSelectedImageName:@"gycommon_tab_easybuy_click" finishedUnselectedImage:@"gycommon_tab_easybuy_normal" tag:2];

        //我的互生 Navigation
        GYHSAccountViewController* hsAccVC = [[GYHSAccountViewController alloc] init];
        [self addChildViewController:hsAccVC title:kLocalized(@"GYHS_Base_tab_my_HS") finishedSelectedImageName:@"gycommon_tab_mine_click" finishedUnselectedImage:@"gycommon_tab_mine_normal" tag:3];

        [self.tabBar setTranslucent:YES];
        //字体颜色与导航条相同
        self.tabBar.tintColor = kNavigationBarColor;
        self.selectedIndex = 1;
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
}

/**
 *    点击我的互生未登录进入登录界面
 *
 *    @param tabBar tabBar对象
 *    @param item   tabBarItem对象
 */
- (void)tabBar:(UITabBar*)tabBar didSelectItem:(UITabBarItem*)item
{

    if (!globalData.isLogined) {
        if (item.tag == 3) {
            if (!globalData.isLogined) {
                // 启动起来默认以有互生卡登录，其他按前一次登录类型判断
                GYHSLoginViewController* loginVcOne = [[GYHSLoginViewController alloc] init];
                loginVcOne.loginType = GYHSLoginViewControllerTypeHashsCard;
                loginVcOne.dismissBarIndex = 1;
                GYNavigationController* loginVc = [[GYNavigationController alloc] initWithRootViewController:loginVcOne];

                [self presentViewController:loginVc animated:YES completion:nil];
                return;
                kCheckLogined
            }
        }
        else if (item.tag == 0) {
            if (!globalData.isLogined) {
                [GYAlertView showMessage:[GYUtils localizedStringWithKey:@"GYHD_Main_reLogin"] cancleButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_cancel"] confirmButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_Main_log_in_immediately"] cancleBlock:nil confirmBlock:^{
                    [[GYHSLoginManager shareInstance] showLoginView:0 otherLogin:NO];
                }];
            }
        }
    }
}

@end
