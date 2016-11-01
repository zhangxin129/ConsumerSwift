//
//  GYHEMapSelectAddressHeaderView.m
//  HSConsumer
//
//  Created by zhengcx on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEMapSelectAddressHeaderView.h"

@interface GYHEMapSelectAddressHeaderView()<UITextFieldDelegate>
@end
@implementation GYHEMapSelectAddressHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    self.backgroundColor = kBackgroundGrayColor;
    self.textFieldBackView.clipsToBounds = YES;
    self.textFieldBackView.layer.cornerRadius = 12;
    self.searchLocalTextField.delegate = self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(searchLocalClickDelegate)]) {
        [self.delegate searchLocalClickDelegate];
    }
    return NO;
}

@end
