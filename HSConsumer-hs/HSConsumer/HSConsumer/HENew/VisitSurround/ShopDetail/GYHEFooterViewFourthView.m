//
//  GYHEFooterViewFourthView.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEFooterViewFourthView.h"

@implementation GYHEFooterViewFourthView



- (void)awakeFromNib
{
    [super awakeFromNib];
    self.cashAmountLabel.text = @"8,938.00";
    self.totalCaculationLabel.text = kLocalized(@"合计:");
    self.pvAmountLabel.text = @"89.38";
    self.couponAmountLabel.text = @"-1,000.00";
    self.totalGoodsDescriptionLabel.text = kLocalized(@"");
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
