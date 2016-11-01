//
//  GYHSTakeAwayDetailSectionFooter.h
//  HSConsumer
//
//  Created by kuser on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSTakeAwayDetailAllModel;

@interface GYHSTakeAwayDetailSectionFooter : UIView

@property (nonatomic, strong) GYHSTakeAwayDetailAllModel* model;

@property (strong, nonatomic) IBOutlet UILabel* totalPriceLabel; //合计
@property (strong, nonatomic) IBOutlet UILabel* totalPVLabel; //积分
@property (strong, nonatomic) IBOutlet UILabel* totalCutLabel; //
@property (strong, nonatomic) IBOutlet UILabel* cutMoneyLabel; //优惠价
@property (strong, nonatomic) IBOutlet UILabel* reallyPayLabel; //实付
@property (strong, nonatomic) IBOutlet UILabel* postPayLabel; //邮费

@end
