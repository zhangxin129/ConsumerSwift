//
//  GYHSLableTextFileTableViewCell.m
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLableTextFileTableViewCell.h"
#import "GYHSConstant.h"
@interface GYHSLableTextFileTableViewCell () <UITextFieldDelegate>
@end

@implementation GYHSLableTextFileTableViewCell

- (void)awakeFromNib
{
    self.titleLabel.textColor = kCellItemTitleColor;
    self.textField.textColor = kCellItemTextColor;
    self.textField.delegate = self;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if ([_textFiledDegelte respondsToSelector:@selector(textField:indextPath:)]) {
        [self.textFiledDegelte textField:textField.text indextPath:self.indexpath];
    }
}
#pragma mark - UITextFieldDelegate
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
