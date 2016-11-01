//
//  GYFoodActeGoryListView.h
//  GYRestaurant
//
//  Created by apple on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYFoodActeGoryListView;
@protocol GYFoodActeGoryListViewDelegate <NSObject>

- (void)GYFoodActeGoryListViewPushVC:(UIButton *)btn
                            sumCount:(int)sumCount;

- (void)GYFoodActeGoryListViewRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface GYFoodActeGoryListView : UIView

@property (nonatomic, strong) NSArray *mdataSource;

@property (nonatomic, weak) UIButton *btnHeader;

@property (nonatomic, weak) id <GYFoodActeGoryListViewDelegate> delegate;

@end
