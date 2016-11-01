//
//  GYAddFoodView.h
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYAddFoodView;
@protocol GYAddFoodViewDelegate <NSObject>

- (void)GYAddFoodViewRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)GYAddFoodViewPushVC:(UIButton *)btn
                   sumCount:(int)sumCount;

@end
@interface GYAddFoodView : UIView
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) UIButton *btnHeader;
@property (nonatomic, weak) UIButton *btnFooter;
@property (nonatomic, weak) id<GYAddFoodViewDelegate>delegate;
@end
