//
//  GYOtherPayStyleViewSpecialCell.m
//  HSConsumer
//
//  Created by Apple03 on 15/12/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOtherPayStyleViewSpecialCell.h"

@implementation GYOtherPayStyleViewSpecialCell

- (void)awakeFromNib
{
    // Initialization code

    self.selected = NO;
    self.currencyAccountPayLabel.text = kLocalized(@"GYHS_Main_Currency_Account_Pay");
    self.balancesLabel.text = kLocalized(@"GYHS_Main_HS_Balances");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //    [super setSelected:selected animated:animated];
}

@end
