//
//  FDChooseFoodTableViewCell.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDChoosedFoodModel.h"

#import "FDSelectFoodViewController.h"
@interface FDChooseFoodTableViewCell : UITableViewCell

@property (strong, nonatomic) FDChoosedFoodModel* model;

@property (weak, nonatomic) FDSelectFoodViewController* delegat;
@property (assign, nonatomic) BOOL isChoosedFoodCell; //判断是否是已点菜品的Cell
@end
