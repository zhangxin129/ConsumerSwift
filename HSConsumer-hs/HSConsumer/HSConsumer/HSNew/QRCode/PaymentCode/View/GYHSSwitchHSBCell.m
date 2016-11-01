//
//  GYHSSwitchHSBCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSSwitchHSBCell.h"
#import "GYHSTools.h"

@implementation GYHSSwitchHSBCell

- (void)awakeFromNib {
    self.valueTextField.delegate = self;
    [self.titleLabel setTextColor:kCellTitleBlack];
    [self.valueTextField setTextColor:kCellTitleBlack];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.valueTextField setFont:[UIFont systemFontOfSize:14]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)switch:(UISwitch *)sender {
    if([_switchHSBDelegate respondsToSelector:@selector(hsbSwitch:indextPath:)]){
        [self.switchHSBDelegate hsbSwitch:sender indextPath:self.indexpath];
    }
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if ([_switchHSBDelegate respondsToSelector:@selector(switchtextField:indextPath:)]) {
        [self.switchHSBDelegate switchtextField:textField.text indextPath:self.indexpath];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text rangeOfString:@"."].location != NSNotFound) {
        textField.text = [textField.text substringToIndex:[textField.text rangeOfString:@"."].location];
        NSMutableString *str1 = [NSMutableString stringWithString:textField.text];
        for (int i = 0; i < str1.length; i++) {
            unichar c = [str1 characterAtIndex:i];
            NSRange range = NSMakeRange(i, 1);
            if ( c == ',') {
                [str1 deleteCharactersInRange:range];
                //--i;
            }
        }
        textField.text = [NSString stringWithString:str1];
    }
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* toBeStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeStr.length > self.textFiledlength) {
        textField.text = [toBeStr substringToIndex:self.textFiledlength];
        return NO;
    }
    return YES;
}

@end
