//
//  GYSyncShopFoodsCollectionView.h
//  GYRestaurant
//
//  Created by apple on 15/10/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYSyncShopFoodsModel.h"
#import "GYSyncShopFoodsCell.h"

#define _CELL @ "acell"

@interface GYSyncShopFoodsCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *mdataSource;


@end
