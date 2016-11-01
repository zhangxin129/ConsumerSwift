//
//  GYHEFooterViewSecondView.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEFooterViewSecondView.h"

@implementation GYHEFooterViewSecondView



-(void)awakeFromNib{
    [super awakeFromNib];
self.realPayCharacterLabel.text = @"实付款";
    [self.commiteOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    self.realToPayLabel.text = @"1,564.00";
    
    
}





//点击提交订单按钮
- (IBAction)commiteOrderBtn:(UIButton *)sender {
    NSLog(@"点击提交订单按钮");
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
