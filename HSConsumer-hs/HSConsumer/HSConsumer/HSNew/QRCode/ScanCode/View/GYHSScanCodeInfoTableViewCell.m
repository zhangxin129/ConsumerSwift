//
//  GYHSScanCodeInfoTableViewCell.m
//  HSConsumer
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSScanCodeInfoTableViewCell.h"

@implementation GYHSScanCodeInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setIsKeepDecimal:(BOOL)isKeepDecimal
{
    _isKeepDecimal = isKeepDecimal;
    if (_isKeepDecimal) {
        self.contentTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self.contentTextField addTarget:self action:@selector(contentChange:) forControlEvents:UIControlEventEditingChanged];
    }else {
    
    }
}

- (void)contentChange:(UITextField *)textField
{
    
    NSRange rangePoint = [textField.text rangeOfString:@"."];
    //刚开始输入.
    if (rangePoint.location != NSNotFound && rangePoint.location == 0)
    {
        textField.text = [NSString stringWithFormat:@"%@%@", @"0", textField.text];
        
    }
    //刚开始没输入.至少保留两位小数
    NSString* regex = @"^\\d+(\\.\\d{0,2})?";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:textField.text];
    if (isMatch) {
        //匹配不做处理
    }else {
        //不匹配去掉最后一位
        if (textField.text.length) {
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
