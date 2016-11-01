//
//  FDSelecteFoodCell.h
//  HSConsumer
//
//  Created by apple on 15/12/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDChoosedFoodModel.h"
#import "FDSelectFoodViewController.h"
#import "FDShopModel.h"
#import "FDFoodModel.h"
@interface FDSelecteFoodCell : UITableViewCell
@property (strong, nonatomic) FDChoosedFoodModel* model;
@property (weak, nonatomic) IBOutlet UILabel* foodName;
@property (weak, nonatomic) IBOutlet UILabel* cashLabel;
@property (weak, nonatomic) IBOutlet UILabel* pvLabel;
@property (weak, nonatomic) IBOutlet UILabel* countLabel;

@property (strong, nonatomic) FDSelectFoodViewController* delegate;
@property (assign, nonatomic) BOOL isChoosedFoodCell; //判断是否是已点菜品的Cell
- (void)cellValueChangedChoosedModel:(FDChoosedFoodModel*)model Cell:(UITableViewCell*)cell View:(UIView*)view;
- (void)showFoodFormatChoosedVC:(FDChoosedFoodModel *)model;
@end
