//
//  GYPaymentPWDTableViewCell.m
//  HSConsumer
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYPaymentPWDTableViewCell.h"

@implementation GYPaymentPWDTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.passWordTextField addTarget:self action:@selector(observerTextFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)observerTextFieldDidChanged:(UITextField *)sender {
    if (sender.text.length > 8) {
        sender.text = [sender.text substringToIndex:8];//使字符串位保持8位
        [sender resignFirstResponder];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
