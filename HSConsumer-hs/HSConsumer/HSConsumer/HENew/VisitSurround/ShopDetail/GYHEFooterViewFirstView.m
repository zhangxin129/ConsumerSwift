//
//  GYHEFooterViewFirstView.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEFooterViewFirstView.h"

@implementation GYHEFooterViewFirstView



-(void)awakeFromNib{
    [super awakeFromNib];
    self.totalCostLabel.text = kLocalized(@"合计:");
    self.cashCostLabel.text = @"10,538.00";
    self.pvAmountLabel.text = @"105.38";
    self.actualyCostLabel.text = @"运费:";
    self.actualyPayLabel.text = @"--";
    self.voucherLeftLabel.text = @"-1,000.00";
    self.allGoodsLabel.text = kLocalized(@"共2件商品");

}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
