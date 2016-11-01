//
//  GYAddFoodCollectionView.h
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#define _CELL @ "addCell"
@protocol GYAddFoodCollectionViewDelegate<NSObject>
- (void)GYAddFoodCollectionViewCellDidClick;
@end
@interface GYAddFoodCollectionView : UIView
@property (nonatomic, strong) NSArray *mdataSource;
@property (nonatomic, weak) UICollectionView *addFoodCollectionView;
@property (nonatomic, assign) id<GYAddFoodCollectionViewDelegate> delegate;

@end
