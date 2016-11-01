//
//  GYHESCOrderTableFooterView.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHESCOrderTableFooterView.h"
#import "GYHESCPaymentMethodsViewController.h"

@implementation GYHESCOrderTableFooterView

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
   }
 */

- (void)awakeFromNib
{
    // Initialization code

    self.paymentMethodTagLabel.text = kLocalized(@"HE_SC_OrderPaymentMethodTitle");
}

- (IBAction)viewTapGestureClick:(UITapGestureRecognizer*)sender
{
    if ([self.delegate respondsToSelector:@selector(pushToChoosePaymentMethod)]) {
        [self.delegate pushToChoosePaymentMethod];
    }
}

@end
