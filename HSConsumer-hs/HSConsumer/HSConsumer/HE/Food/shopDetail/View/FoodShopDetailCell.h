//
//  FoodShopDetailCell.h
//  HSConsumer
//
//  Created by apple on 15/12/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDShopDetailModel.h"
@interface FoodShopDetailCell : UITableViewCell
@property (nonatomic, strong) FDShopDetailModel* shopDetailModel;
@property(nonatomic, strong) UILabel *infoLabel;
@end
