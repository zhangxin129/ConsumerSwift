//
//  GYEvaluationTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEvaluateGoodModel.h"
@interface GYEvaluationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView* vWhiteBackground;
@property (weak, nonatomic) IBOutlet UIImageView* imgvGoods;
@property (weak, nonatomic) IBOutlet UILabel* lbGoodTitle;
@property (weak, nonatomic) IBOutlet UILabel* lbGoodShop;
@property (weak, nonatomic) IBOutlet UIButton* btnMakeEvalutaion;
@property (nonatomic, strong) GYEvaluateGoodModel *model;

- (void)refreshUIWithModel:(GYEvaluateGoodModel*)model WithType:(int)cellType;
@end
