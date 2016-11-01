//
//  GYHESCOrderTableHeaderView.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/28.
//  Copyright © 2016年 zhangqy. All rights reserved.
//

#import "GYHESCOrderTableHeaderView.h"

@implementation GYHESCOrderTableHeaderView

- (void)awakeFromNib
{
    // Initialization code
}

//手势点击方法
- (IBAction)viewTapGestureClick:(UITapGestureRecognizer*)sender
{
    if ([self.delegate respondsToSelector:@selector(pushToChooseReceiveAddress)]) {
        [self.delegate pushToChooseReceiveAddress];
    }
}

- (IBAction)addressButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(pushToChooseReceiveAddress)]) {
        [self.delegate pushToChooseReceiveAddress];
    }
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
   }
 */

@end
