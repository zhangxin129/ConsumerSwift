//
//  GYAddFoodHeaderView.h
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYNavBarView;
@protocol GYNavBarViewDelegate <NSObject>

- (void)GYNavBarViewpopBack;
- (void)GYNavBarViewAddFood:(UIButton *)button dishNum:(int)disnNum;
- (void)GYNavBarViewAddsearchFoodAAA:(NSString *)searchTFText;
@end
@interface GYNavBarView : UIView
@property (nonatomic, weak) UILabel *lbShowOrderNumber;
@property (nonatomic, weak) UILabel *lbShowOrderPrice;
@property (nonatomic, weak) id<GYNavBarViewDelegate>delegate;
@property (nonatomic, assign) int sum;

@end
