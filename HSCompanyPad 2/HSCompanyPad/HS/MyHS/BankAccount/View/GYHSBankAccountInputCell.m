//
//  GYHSBankAccountInputCell.m
//  HSCompanyPad
//
//  Created by 梁晓辉 on 16/8/14.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSBankAccountInputCell.h"
#import "GYAddressCountryModel.h"
#import "GYAreaHttpTool.h"
#import "GYHSBankPopVC.h"
#import "GYHSmyhsHttpTool.h"
#import <GYKit/GYPinYinConvertTool.h>
#import "GYShowPullDownViewVC.h"
#define kLineHeight 0.5
#define kBorderColor [UIColor colorWithRed:200 / 255.0f green:200 / 255.0f blue:200 / 255.0f alpha:1]
#define kEdgeInset UIEdgeInsetsMake(8, 8, 8, 8)
#define kFieldTag 100
#define ALPHA_ARRAY [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil]

static NSString* firstCell = @"bankAccountInputFirst";
static NSString* secondCell = @"bankAccountInputSecond";
static NSString* thirdCell = @"bankAccountInputThird";
static NSString* fourCell = @"bankAccountInputFour";

@interface GYHSBankAccountInputCell () <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel* firstRightLabel;
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel* firstLeftLabel;
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel* secondLabel;
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel* fourthLabel;
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel* thirdLabel;
@property (weak, nonatomic) IBOutlet GYHSCunsumeTextField* thirdLeftField;
@property (weak, nonatomic) IBOutlet UIButton* nonButton;
@property (weak, nonatomic) IBOutlet UIButton* tureButton;
@property (nonatomic, copy) NSString* isDefault; //设置默认0否、1是
@end
@implementation GYHSBankAccountInputCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.firstRightLabel.edgeInsets = kEdgeInset;
    self.firstLeftLabel.edgeInsets = kEdgeInset;
    self.secondLabel.edgeInsets = kEdgeInset;
    self.thirdLabel.edgeInsets = kEdgeInset;
    self.fourthLabel.edgeInsets = kEdgeInset;
    self.secondTextField.delegate = self;
    self.thirdLeftField.delegate = self;
    self.thirdRightField.delegate = self;
    self.isDefault = @"0";
    [self.nonButton setTitle:kLocalized(@"GYHS_Myhs_No") forState:UIControlStateNormal];
    [self.nonButton setImage:[UIImage imageNamed:@"gyhs_check_select"] forState:UIControlStateNormal];
    [self.tureButton setTitle:kLocalized(@"GYHS_Myhs_Yes") forState:UIControlStateNormal];
    [self.tureButton setImage:[UIImage imageNamed:@"gyhs_check_noselect"] forState:UIControlStateNormal];
}
- (IBAction)click:(UIButton*)sender
{
    if (sender.tag == self.nonButton.tag) {
        [self.nonButton setImage:[UIImage imageNamed:@"gyhs_check_select"] forState:UIControlStateNormal];
        [self.tureButton setImage:[UIImage imageNamed:@"gyhs_check_noselect"] forState:UIControlStateNormal];
        self.isDefault = @"0";
    } else {
        [self.nonButton setImage:[UIImage imageNamed:@"gyhs_check_noselect"] forState:UIControlStateNormal];
        [self.tureButton setImage:[UIImage imageNamed:@"gyhs_check_select"] forState:UIControlStateNormal];
        self.isDefault = @"1";
    }
    if (_delegate && [_delegate respondsToSelector:@selector(setIsDefault:)]) {
        [_delegate bankDefault:self.isDefault];
    }
}

+ (instancetype)tableViewCellWith:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath dataArray:(NSMutableArray*)dataArray placeholderArray:(NSMutableArray*)placeholderArray
{
    NSString* identifier = @""; //对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    if (indexPath.row == 0 || indexPath.row == 1) {
        identifier = firstCell;
        index = 0;
    } else if (indexPath.row == 6) {
        identifier = fourCell;
        index = 3;
    } else if (indexPath.row == 3) {
        identifier = thirdCell;
        index = 2;
    } else {
        identifier = secondCell;
        index = 1;
    }
    GYHSBankAccountInputCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSBankAccountInputCell class]) owner:self options:nil] objectAtIndex:index];
    }
    if (indexPath.row == 2 || indexPath.row == 3) {
        [cell setRightViewWithTextField:cell.secondTextField imageName:@"gycom_gray_pullDown"];
        [cell setRightViewWithTextField:cell.thirdLeftField imageName:@"gycom_gray_pullDown"];
        [cell setRightViewWithTextField:cell.thirdRightField imageName:@"gycom_gray_pullDown"];
    }
    cell.firstLeftLabel.text = dataArray[indexPath.row];
    cell.secondLabel.text = dataArray[indexPath.row];
    cell.thirdLabel.text = dataArray[indexPath.row];
    cell.fourthLabel.text = dataArray[indexPath.row];
    if ([identifier isEqualToString:secondCell]) {
        cell.secondTextField.placeholder = placeholderArray[indexPath.row - 2];
        cell.secondTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.secondTextField.tag = kFieldTag + indexPath.row;
    } else if ([identifier isEqualToString:thirdCell]) {
        cell.thirdLeftField.placeholder = placeholderArray[indexPath.row - 2][0];
        cell.thirdRightField.placeholder = placeholderArray[indexPath.row - 2][1];
        cell.thirdLeftField.tag = kFieldTag;
        cell.thirdRightField.tag = kFieldTag + 1;
    } else if ([identifier isEqualToString:firstCell]) {
        NSArray* arry = @[ globalData.loginModel.entCustName, globalData.config.currencyName ];
        cell.firstRightLabel.text = arry[indexPath.row];
    }
    return cell;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField.tag == kFieldTag || textField.tag == kFieldTag + 1 || textField.tag == kFieldTag + 2) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{

    NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    //银行账户5~30
    if (toBeString.length > 30) {
        [self endEditing:YES];
        return NO;
    }
    return YES;
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    [self endEditing:YES];
    if ([touch.view isKindOfClass:[UITextField class]]) {
        UITextField* textField = (UITextField*)touch.view;
        NSInteger tag = textField.tag - kFieldTag;
        if (_delegate && [_delegate respondsToSelector:@selector(clickWithCell:textField:tag:)]) {
            [_delegate clickWithCell:self textField:textField tag:tag];
        }
    }
    
    return NO;
}

- (void)setRightViewWithTextField:(GYHSCunsumeTextField*)textField imageName:(NSString*)imageName
{

    UIImageView* rightView = [[UIImageView alloc] init];
    rightView.image = [UIImage imageNamed:imageName];
    rightView.size = CGSizeMake(30, 30);
    rightView.contentMode = UIViewContentModeCenter;
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft | UIViewCustomBorderTypeBottom;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
