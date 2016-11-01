//
//  UIViewController+GYExtension.m
//  company
//
//  Created by sqm on 16/5/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "UIViewController+GYExtension.h"
#import <objc/runtime.h>
#import "Aspects.h"

static const void* noNetWorkViewKey = &noNetWorkViewKey;
static const void* noNetWorkBlockKey = &noNetWorkBlockKey;

@implementation UIViewController (GYExtension)

#pragma mark - 无网络情况的处理

- (void)setNoNetWorkView:(UIView*)noNetWorkView
{
    objc_setAssociatedObject(self, noNetWorkViewKey, noNetWorkView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)noNetWorkView
{
    return objc_getAssociatedObject(self, noNetWorkViewKey);
}

- (void)setNoNetBlock:(dispatch_gyNonet_block)noNetBlock
{
    if (noNetBlock) {
        objc_setAssociatedObject(self, noNetWorkBlockKey, noNetBlock, OBJC_ASSOCIATION_COPY);
    }
}

- (dispatch_gyNonet_block)noNetBlock
{

    return objc_getAssociatedObject(self, noNetWorkBlockKey);
}

#pragma mark - 关于包装了Navigation的一些方法
/**
 *  @brief  寻找Navigation中的某个viewcontroler对象
 *
 *  @param className viewcontroler名称
 *
 *  @return viewcontroler对象
 */
- (id)findViewController:(NSString*)className
{
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(className)]) {
            return viewController;
        }
    }

    return nil;
}
/**
 *  @brief  判断是否只有一个RootViewController
 *
 *  @return 是否只有一个RootViewController
 */
- (BOOL)isOnlyContainRootViewController
{
    if (self.navigationController.viewControllers && self.navigationController.viewControllers.count == 1) {
        return YES;
    }
    return NO;
}
/**
 *  @brief  RootViewController
 *
 *  @return RootViewController
 */
- (UIViewController*)rootViewController
{
    if (self.navigationController.viewControllers && [self.navigationController.viewControllers count] > 0) {
        return [self.navigationController.viewControllers firstObject];
    }
    return nil;
}
/**
 *  @brief  返回指定的viewcontroler
 *
 *  @param className 指定viewcontroler类名
 *  @param animated  是否动画
 *
 *  @return pop之后的viewcontrolers
 */
- (NSArray*)popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;
{
    return [self.navigationController popToViewController:[self findViewController:className] animated:YES];
}
/**
 *  @brief  pop n层
 *
 *  @param level  n层
 *  @param animated  是否动画
 *
 *  @return pop之后的viewcontrolers
 */
- (NSArray*)popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated
{
    NSInteger viewControllersCount = self.navigationController.viewControllers.count;
    if (viewControllersCount > level) {
        NSInteger idx = viewControllersCount - level - 1;
        UIViewController* viewController = self.navigationController.viewControllers[idx];
        return [self.navigationController popToViewController:viewController animated:animated];
    } else {
        return [self.navigationController popToRootViewControllerAnimated:animated];
    }
    
}






@end
