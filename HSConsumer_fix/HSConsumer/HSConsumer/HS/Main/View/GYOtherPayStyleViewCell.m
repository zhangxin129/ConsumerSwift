//
//  GYOtherPayStyleViewCell.m
//  HSConsumer
//
//  Created by Apple03 on 15/12/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOtherPayStyleViewCell.h"

@implementation GYOtherPayStyleViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.localSettlementCurrencyLabel.text = kLocalized(@"GYHS_Main_Local_Set_tlement_Currency");
    self.currencyConversionRatioLabel.text = kLocalized(@"GYHS_Main_Currency_ConversionRatio");
    self.convertCurrencyAmountLabel.text = kLocalized(@"GYHS_Main_Convert_Currency_Amount");
    self.theYuanLabel.text = kLocalized(@"GYHS_Main_TheYuan");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //    [super setSelected:selected animated:animated];
}

@end
