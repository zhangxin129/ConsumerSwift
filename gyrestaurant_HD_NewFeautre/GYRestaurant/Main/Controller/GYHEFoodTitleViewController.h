//
//  GYHEFoodTitleViewController.h
//  GYFood
//
//  Created by apple on 15/10/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHEFoodTitleViewController;
@protocol GYHEFoodTitleViewControllerDelegate<UITableViewDelegate>
- (void)foodTitleViewController: (GYHEFoodTitleViewController *) titleVc didSelectedIndex:(int) index;
@end
@interface GYHEFoodTitleViewController : UIViewController
@property (nonatomic, weak) id<GYHEFoodTitleViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, copy) NSString * heardString;
@property (nonatomic, assign) BOOL flag;
-(id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array heardTitle:(NSString *)heardTitle select:(BOOL)select;
@end
