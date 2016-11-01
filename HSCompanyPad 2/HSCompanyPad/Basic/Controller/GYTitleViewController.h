//
//  GYTitleViewController.h
//  GYRestaurant
//
//  Created by kuser on 15/10/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYTitleViewController;

@protocol GYTitleViewControllerDelegate <UITableViewDelegate>

- (void)titleViewController:(GYTitleViewController*)titleVc didSelectedIndex:(int)index;

@end

@interface GYTitleViewController : UITableViewController
@property (nonatomic, strong) NSArray* dataSource;
@property (nonatomic, weak) id<GYTitleViewControllerDelegate> delegate;

@end
