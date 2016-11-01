//
//  UIViewController+GYExtension.m
//  company
//
//  Created by sqm on 16/5/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "UIViewController+GYExtension.h"
#import <objc/runtime.h>
#import <Aspects/Aspects.h>

static const void *noNetWorkViewKey = &noNetWorkViewKey;
static const void *noNetWorkBlockKey = &noNetWorkBlockKey;

@implementation UIViewController (GYExtension)


#pragma mark - 无网络情况的处理

- (void)setNoNetWorkView:(UIView *)noNetWorkView
{
  objc_setAssociatedObject(self,  noNetWorkViewKey, noNetWorkView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}


- (UIView *)noNetWorkView
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
    for (UIViewController *viewController in self.navigationController.viewControllers) {
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
    if (self.navigationController.viewControllers &&
        self.navigationController.viewControllers.count == 1) {
        return YES;
    }
    return NO;
}
/**
 *  @brief  RootViewController
 *
 *  @return RootViewController
 */
- (UIViewController *)rootViewController
{
    if (self.navigationController.viewControllers && [self.navigationController.viewControllers count] >0) {
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
- (NSArray *)popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;
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
- (NSArray *)popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated
{
    NSInteger viewControllersCount = self.navigationController.viewControllers.count;
    if (viewControllersCount > level) {
        NSInteger idx = viewControllersCount - level - 1;
        UIViewController *viewController = self.navigationController.viewControllers[idx];
        return [self.navigationController popToViewController:viewController animated:animated];
    } else {
        return [self.navigationController popToRootViewControllerAnimated:animated];
    }
    
}


#pragma mark重新加载数据
- (void)loadAndTapReloadNetData{
    if (self.noNetBlock && globalData.isOnNet) {
        self.noNetBlock();
        [self.noNetWorkView removeFromSuperview];
    }
    
}

#pragma mark无网络页面
- (void)customNoNetWorkView{
    if (self.noNetWorkView) {
        return;
    }
   UIView  *backView = [[UIView alloc]initWithFrame:self.view.bounds];
    backView.backgroundColor = kDefaultVCBackgroundColor;
    backView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *reloadTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadAndTapReloadNetData)];
    [backView addGestureRecognizer:reloadTap];
    [self.view addSubview:backView];
    
    UIImageView *noConnectImage = [[UIImageView alloc]initWithFrame:CGRectMake(100,0, 145, 95)];
    UIImage *image = [UIImage imageNamed:@"no_neAlertt"];
    noConnectImage.image = image;
    [backView addSubview:noConnectImage];
    noConnectImage.center = CGPointMake(self.view.centerX, self.view.centerY - 80);
    
   UILabel *noConnectLabel = [[UILabel alloc]initWithFrame:CGRectMake(noConnectImage.x - 30, CGRectGetMaxY(noConnectImage.frame) + 5, noConnectImage.width + 60, 15)];
    noConnectLabel.text = @"您的网络已经离开地球了!";
    noConnectLabel.textAlignment = NSTextAlignmentCenter;
    noConnectLabel.textColor =  [UIColor colorWithHexString:@"#a7a7a7"];
    noConnectLabel.numberOfLines = 0;
    noConnectLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:noConnectLabel];
    
   UILabel *subNoConectLabel = [[UILabel alloc]initWithFrame:CGRectMake(noConnectImage.x, CGRectGetMaxY(noConnectLabel.frame) + 9, noConnectImage.width, 12)];
    subNoConectLabel.text = @"请检查网络点击重试";
    subNoConectLabel.textAlignment = NSTextAlignmentCenter;
    subNoConectLabel.textColor = [UIColor colorWithHexString:@"#a7a7a7"];
    subNoConectLabel.font = [UIFont systemFontOfSize:12];
    [backView addSubview:subNoConectLabel];
    self.noNetWorkView = backView;

    [self.view bringSubviewToFront:backView];
    
}




@end
