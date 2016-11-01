//
//  GYAddFoodShowCell.h
//  GYRestaurant
//
//  Created by apple on 15/11/2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYSyncShopFoodsModel.h"
@interface GYAddFoodShowCell : UITableViewCell
@property (nonatomic, strong) id sfModel;
@property (nonatomic, assign) int totalPrice;
@property (nonatomic, assign) int totalPV;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;


@end
