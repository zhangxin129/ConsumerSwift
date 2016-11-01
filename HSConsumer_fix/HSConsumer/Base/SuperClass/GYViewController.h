//
//  GYViewController.h
//  HSConsumer
//
//  Created by kuser on 15/10/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYViewController : UIViewController

/**
 * 无网络视图
 */
- (void)showNoNetworkView;

/**
 *  隐藏无网络视图
 */
- (void)dismissNoNetworkView;

/**
 *  无重新加载数据
 */
- (void)reloadNetworkData;

/**
 *  返回指定的viewcontroler
 *  @param className 指定viewcontroler类名
 *  @param animated  是否动画
 *  @return pop之后的viewcontrolers
 */
- (NSArray*)popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;

@end
