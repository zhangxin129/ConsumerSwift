//
//  GYStarTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"
@interface GYStarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton* btnStar1;

//__weak IBOutlet UIButton *btnStar2;//星星2

@property (weak, nonatomic) IBOutlet UIButton* btnStar2;

@property (weak, nonatomic) IBOutlet UIButton* btnStar3;
@property (weak, nonatomic) IBOutlet UIButton* btnStar4;
@property (weak, nonatomic) IBOutlet UIButton* btnStar5;

//__weak IBOutlet UILabel *lbPoint;//评分
//
//__weak IBOutlet UILabel *lbEvaluatePerson;//评分人数
@property (weak, nonatomic) IBOutlet UILabel* lbPoint;

@property (weak, nonatomic) IBOutlet UILabel* lbEvaluatePerson;

- (void)refreshUIWithModel:(ShopModel *)model;
@end
