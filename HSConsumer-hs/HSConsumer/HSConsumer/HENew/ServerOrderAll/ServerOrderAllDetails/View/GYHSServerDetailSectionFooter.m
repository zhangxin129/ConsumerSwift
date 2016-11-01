//
//  GYHSServerDetailSectionFooter.m
//  HSConsumer
//
//  Created by zhengcx on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSServerDetailSectionFooter.h"
#import "GYHSServerDetailAllModel.h"

@implementation GYHSServerDetailSectionFooter

- (void)awakeFromNib
{
    self.reallyPayLabel.textColor = kCorlorFromHexcode(0xff5000);
    self.reallyPayLabel.font = [UIFont systemFontOfSize:14];
    self.postPayLabel.textColor = kCorlorFromHexcode(0xff5000);
    self.postPayLabel.font = [UIFont systemFontOfSize:14];
    self.totalPriceLabel.textColor = kCorlorFromHexcode(0xff5000);
    self.totalPriceLabel.font = [UIFont systemFontOfSize:14];
    self.totalPVLabel.textColor = kCorlorFromHexcode(0x1d7dd6);
    self.totalPVLabel.font = [UIFont systemFontOfSize:14];
    self.totalCutLabel.textColor = kCorlorFromHexcode(0x333333);
    self.totalCutLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setModel:(GYHSServerDetailAllModel*)model
{
    _model = model;
    self.reallyPayLabel.text = [GYUtils formatCurrencyStyle:[model.reallyPay doubleValue]];
    self.postPayLabel.text = [GYUtils formatCurrencyStyle:[model.postPay doubleValue]];
    self.totalPriceLabel.text = [GYUtils formatCurrencyStyle:[model.totalPrice doubleValue]];
    self.totalPVLabel.text = [GYUtils formatCurrencyStyle:[model.totalPrice doubleValue]];
    self.cutMoneyLabel.text = [GYUtils formatCurrencyStyle:[model.cutMoney doubleValue]];
    self.totalCutLabel.text = [NSString stringWithFormat:@"共%@件商品", model.totalCut];
}

@end
