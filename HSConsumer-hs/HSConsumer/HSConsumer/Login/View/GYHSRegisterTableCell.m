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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* smsBtnWidth;

@property (weak, nonatomic) IBOutlet UIButton* smsCodeButton;
@property (weak, nonatomic) IBOutlet UIView* arrowBGView;
@property (weak, nonatomic) IBOutlet UIImageView* arrowImageView;

@property (weak, nonatomic) IBOutlet UIView* rightLineView;

@property (strong, nonatomic) NSIndexPath* indexPath;
@property (assign, nonatomic) NSInteger maxSize;
@end

@implementation GYHSRegisterTableCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.smsCodeButton setTitle:kLocalized(@"点击获取") forState:UIControlStateNormal];
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
    [self.valueTextField setFont:[UIFont systemFontOfSize:14]];
    
    if (value.length >= 8) {
        [self.valueTextField setFont:[UIFont systemFontOfSize:13]];
    }
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

    if (self.isNotShowLine) {
        self.rightLineView.hidden = YES;
        [self.smsCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

    if (!showSmsBtn) {
        self.smsBtnWidth.constant = 0;
    }

    if (showArrowBtn) {
        self.arrowBGView.hidden = NO;
        self.valueTextField.enabled = NO;
        self.smsBtnWidth.constant = self.arrowBGView.frame.size.width;
    }

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
}

- (void)changeArrowImage:(NSString*)imageName
{
    CGRect frame = self.arrowImageView.frame;
    frame.size = CGSizeMake(13, 7);
    self.arrowImageView.frame = frame;
    self.arrowImageView.image = [UIImage imageNamed:imageName];
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

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    if ([self.cellDelegate respondsToSelector:@selector(keyBoardAppearWhenEditing:indexPath:)]) {
        [self.cellDelegate keyBoardAppearWhenEditing:textField indexPath:self.indexPath];
    }
}

@end
