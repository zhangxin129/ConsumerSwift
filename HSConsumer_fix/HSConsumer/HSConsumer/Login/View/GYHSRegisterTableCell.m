//
//  GYHSRegisterTableCell.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSRegisterTableCell.h"
#import "GYHSConstant.h"
@interface GYHSRegisterTableCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel* nameLable;
@property (weak, nonatomic) IBOutlet UITextField* valueTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* textFieldWidth;

@property (weak, nonatomic) IBOutlet UIButton* smsCodeButton;
@property (weak, nonatomic) IBOutlet UIView* arrowBGView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@property (strong, nonatomic) NSIndexPath* indexPath;
@property (assign, nonatomic) NSInteger maxSize;
@end

@implementation GYHSRegisterTableCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.smsCodeButton setTitle:kLocalized(@"GYHS_Login_Get_Verification_Code") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - public methods
- (void)setCellValue:(NSString*)name
               value:(NSString*)value
         placeHolder:(NSString*)placeHolder
             pwdType:(BOOL)pwdType
             maxSize:(NSInteger)maxSize
         keyBoardNum:(BOOL)keyBoardNum
          showSmsBtn:(BOOL)showSmsBtn
        showArrowBtn:(BOOL)showArrowBtn
           indexPath:(NSIndexPath*)indexPath
{

    self.nameLable.text = name;

    self.valueTextField.text = value;
    self.valueTextField.placeholder = placeHolder;
    self.valueTextField.delegate = self;
    [self.valueTextField addTarget:self action:@selector(changeTextFieldAction:) forControlEvents:UIControlEventEditingChanged];

    self.valueTextField.keyboardType = UIKeyboardTypeDefault;
    if (keyBoardNum) {
        self.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
    }

    self.valueTextField.secureTextEntry = NO;
    if (pwdType) {
        self.valueTextField.secureTextEntry = YES;
    }

    self.smsCodeButton.hidden = YES;
    self.rightLineView.hidden = YES;
    
    self.arrowBGView.hidden = YES;
    if (showSmsBtn) {
        self.smsCodeButton.hidden = NO;
        self.rightLineView.hidden = NO;
        [self.rightLineView setTintColor:kLineViewColor];
    }

    if (showArrowBtn) {
        self.arrowBGView.hidden = NO;
        self.valueTextField.enabled = NO;
    }

    CGFloat width = kScreenWidth - 98 - 15 - 83;
    if (!showSmsBtn && !showArrowBtn) {
        width = kScreenWidth - 98 - 15;
    }
    self.textFieldWidth.constant = width;

    self.indexPath = indexPath;
    self.maxSize = maxSize;
}

- (void)setValueTextFieldEnable:(BOOL)enable
{
    if (enable) {
        self.valueTextField.enabled = YES;
    }
    else {
        self.valueTextField.enabled = NO;
        self.valueTextField.textColor = kgrayTextColor;
    }
}

- (void)updateSMSTitle:(NSString*)title
{
    [self.smsCodeButton setTitle:title forState:UIControlStateNormal];
    
//    self.smsCodeButton.layer.borderWidth = 1.0;
//    self.smsCodeButton.layer.borderColor = kCorlorFromRGBA(239, 65, 54, 1).CGColor;
//    self.smsCodeButton.layer.cornerRadius = 5.0f;
}

- (IBAction)smsCodeButtonAction:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonAction:indexPath:)]) {
        [self.cellDelegate buttonAction:sender indexPath:self.indexPath];
    }
}

- (IBAction)arrowButtonAction:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonAction:indexPath:)]) {
        [self.cellDelegate buttonAction:sender indexPath:self.indexPath];
    }
}

- (void)changeTextFieldAction:(UITextField*)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(inputTextField:indexPath:)]) {
        [self.cellDelegate inputTextField:sender.text indexPath:self.indexPath];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{

    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (toBeString.length > self.maxSize) {
        return NO;
    }

    return YES;
}

@end
