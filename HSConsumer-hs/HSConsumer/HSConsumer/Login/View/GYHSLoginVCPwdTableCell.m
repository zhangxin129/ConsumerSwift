//
//  GYHSLoginVCPwdTableCell.m
//  HSConsumer
//
//  Created by wangfd on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginVCPwdTableCell.h"

@interface GYHSLoginVCPwdTableCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField* pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton* pwdBtn;
@property (strong, nonatomic) NSIndexPath* indexPath;

@end

@implementation GYHSLoginVCPwdTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.pwdTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellValue:(NSString*)placeHolder
             btnName:(NSString*)btnName
           indexPath:(NSIndexPath*)indexPath
{
    self.pwdTextField.placeholder = placeHolder;
    self.pwdTextField.delegate = self;
    self.pwdTextField.secureTextEntry = YES;

    [self.pwdBtn setTitle:btnName forState:UIControlStateNormal];
    self.indexPath = indexPath;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if ([self.cellDelegate respondsToSelector:@selector(pwdInputTextField:indexPath:)]) {
        [self.cellDelegate pwdInputTextField:textField indexPath:self.indexPath];
    }

    return YES;
}

- (IBAction)pwdBtnAction:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(forgetPwdBtnAction:)]) {
        [self.cellDelegate forgetPwdBtnAction:self.indexPath];
    }
}

@end
