//
//  GYHDNavigationController.m
//  HSConsumer
//
//  Created by shiang on 16/6/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDNavigationController.h"

@implementation GYHDNavigationController

//+ (void)initialize
//{
//
//    [super initialize];
//
//
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = kNavigationBarColor;
////    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//
////    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
////                                    kNavigationTitleColor, NSForegroundColorAttributeName,
////                                    kNavigationTitleColor, NSBackgroundColorAttributeName,
////                                    [UIFont systemFontOfSize:19.0f], NSFontAttributeName, nil];
//
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:attDict];
////    [[UINavigationBar appearance] setBackgroundColor:kClearColor];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
//}

- (instancetype)initWithRootViewController:(UIViewController*)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        [self.navigationBar setTranslucent:NO];
        //        self.delegate = self;
    }
    return self;
}

- (void)popself
{
    [self popViewControllerAnimated:YES];
    
    UIViewController *vc = self.viewControllers.lastObject;
    
         if(![(NSStringFromClass(self.viewControllers.lastObject.class))hasPrefix:@"GYHD"])
         {
            vc.navigationController.navigationBar.barTintColor = kNavigationBarColor;
             NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
             attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
             [vc.navigationController.navigationBar setTitleTextAttributes:attDict];
             
         }else{
             vc.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
             NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
             attDict[NSForegroundColorAttributeName] = [UIColor blackColor];
             [vc.navigationController.navigationBar setTitleTextAttributes:attDict];
    }
}




- (UIBarButtonItem*)createBackButtonWithImage:(NSString *)image
{
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated
{

    if (!globalData.isOnNet && self.viewControllers.count > 1) { //此处判断，防止无网络的时候推出页面，没有数据。
        return;
    }
    
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1) {
        
        
        if(![(NSStringFromClass([viewController class]))hasPrefix:@"GYHD"])
        {
            
            
               viewController.navigationController.navigationBar.barTintColor = kNavigationBarColor;
            NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
            attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
            [viewController.navigationController.navigationBar setTitleTextAttributes:attDict];
            viewController.navigationItem.leftBarButtonItem = [self createBackButtonWithImage:@"gycommon_nav_back"];
            
        }else{
            viewController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
            attDict[NSForegroundColorAttributeName] = [UIColor blackColor];kNavigationBarColor;
            [viewController.navigationController.navigationBar setTitleTextAttributes:attDict];
            viewController.navigationItem.leftBarButtonItem = [self createBackButtonWithImage:@"gyhd_back_icon"];

            
        }
       
    }
    
}


@end
