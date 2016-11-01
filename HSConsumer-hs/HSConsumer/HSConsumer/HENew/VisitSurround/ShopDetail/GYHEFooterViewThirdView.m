//
//  GYHEFooterViewThirdView.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEFooterViewThirdView.h"

@implementation GYHEFooterViewThirdView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.descriptionLabel.text = @"免费预约/预订";
    [self.commiteOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];

}





//点击提交订单
- (IBAction)commiteOrderBtn:(UIButton *)sender {
    NSLog(@"点击提交订单2");
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
