//
//  GYHSServerDetailSectionFooter.h
//  HSConsumer
//
//  Created by zhengcx on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSServerDetailAllModel;

@interface GYHSServerDetailSectionFooter : UIView

@property (nonatomic, strong) GYHSServerDetailAllModel* model;

@property (strong, nonatomic) IBOutlet UILabel* reallyPayLabel;
@property (strong, nonatomic) IBOutlet UILabel* totalCutLabel;
@property (strong, nonatomic) IBOutlet UILabel* totalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel* cutMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel* postPayLabel;
@property (strong, nonatomic) IBOutlet UILabel* totalPVLabel;

@end
