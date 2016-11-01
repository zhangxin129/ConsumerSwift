//
//  GYHSNonQuickBankBindingView.m
//  HSConsumer
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSNonQuickBankBindingView.h"

@implementation GYHSNonQuickBankBindingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.tipLabel.text = kLocalized(@"GYHS_Banding_Tip_You_Have_Not_Yet_Bund_Fast_Payment_Card_Record");
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
}

@end
