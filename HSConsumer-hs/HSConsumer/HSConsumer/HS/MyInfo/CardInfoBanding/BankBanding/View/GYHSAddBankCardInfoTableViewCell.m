//
//  GYHSAddBankCardInfoTableViewCell.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAddBankCardInfoTableViewCell.h"


@interface GYHSAddBankCardInfoTableViewCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel* nameLable;
@property (weak, nonatomic) IBOutlet UITextField* valueTextField;

@property (weak, nonatomic) IBOutlet UIButton* selectButton;

@property (weak, nonatomic) IBOutlet UIImageView* bgBtnImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonWidth;

@property (nonatomic, strong) NSIndexPath* cellIndexPath;

@end

@implementation GYHSAddBankCardInfoTableViewCell

#pragma mark - life cycle
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setCellValue:(NSString*)title
               value:(NSString*)value
          valueColor:(UIColor*)valueColor
           valueEdit:(BOOL)valueEdit
           imageName:(NSString*)imageName
         arrowButton:(BOOL)arrowButton
         placeholder:(NSString*)placeholder
                 tag:(NSIndexPath*)indexPath
{
    self.nameLable.text = title;
    self.valueTextField.text = value;
    self.valueTextField.textColor = valueColor;
    self.valueTextField.placeholder = placeholder;
    self.valueTextField.enabled = NO;
    [self.valueTextField addTarget:self action:@selector(changeTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
    if (valueEdit) {
        self.valueTextField.enabled = YES;
        self.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    self.selectButton.hidden = YES;
    self.bgBtnImageView.hidden = YES;
    if (![GYUtils checkStringInvalid:imageName]) {
        self.selectButton.hidden = NO;
        self.bgBtnImageView.hidden = NO;
        self.bgBtnImageView.image = [UIImage imageNamed:imageName];
        if (arrowButton) {
            self.imageWidth.constant = 10;
            self.imageHeight.constant = 16;
        }
    }
    self.cellIndexPath = indexPath;
    if (indexPath.row == 4 || indexPath.row == 5)  {
        self.imageWidth.constant = 0;
        self.selectButtonWidth.constant  = 0;
    }
    self.valueTextField.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSString*)valueInfo
{
    return self.valueTextField.text;
}

- (void)setValueInfo:(NSString*)value
{
    self.valueTextField.text = value;
}

- (void)numberKeyBoard
{
    self.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
}

#pragma mark - UITextFieldDelegate
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (len > 30) {
        [self endEditing:YES];
        return NO;
    }
    NSCharacterSet* cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

- (void)changeTextFieldAction:(UITextField*)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(inputValue:indexPath:)]) {
        [self.cellDelegate inputValue:sender.text indexPath:self.cellIndexPath];
    }
}

#pragma mark - event response
- (IBAction)imageButtonAction:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(chooseButtonAction:)]) {
        [self.cellDelegate chooseButtonAction:self.cellIndexPath];
    }
}

@end
