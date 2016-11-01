//
//  GYHSPointTimeView.m
//
//  Created by apple on 16/8/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointTimeView.h"
#import "GYDatePickView.h"
#import "GYHSCunsumeTextField.h"
#import "GYHSPublicMethod.h"
#define kTopHeight kDeviceProportion(6)
#define kLeftWidth kDeviceProportion(10)
#define kCardWidth kDeviceProportion(160)
#define kCommonHeight kDeviceProportion(25)
#define kButtonWidth kDeviceProportion(60)
#define kTimeFieldWidth kDeviceProportion(130)
#define kImageSize kDeviceProportion(14)
#define kBtnWidth kDeviceProportion(40)
#define kBackViewHeight kDeviceProportion(36)
#define kDateInterval 15
@interface GYHSPointTimeView () <UITextFieldDelegate, UIGestureRecognizerDelegate>


@end
@implementation GYHSPointTimeView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    UIView* backview = [[UIView alloc] init];
    backview.y = kTopHeight;
    backview.height = kBackViewHeight;
    [self addSubview:backview];
    
    //互生卡
    GYHSCunsumeTextField* cardField = [[GYHSCunsumeTextField alloc] initWithFrame:CGRectMake(kLeftWidth, 0, kCardWidth, kCommonHeight)];
    cardField.centerY = kBackViewHeight / 2;
    cardField.placeholder = kLocalized(@"GYHS_Point_Hs_Card");
    cardField.layer.borderWidth = 1;
    cardField.layer.borderColor = kDefaultVCBackgroundColor.CGColor;
    
    cardField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cardField.keyboardType = UIKeyboardTypeNumberPad;
    cardField.delegate = self;
    [backview addSubview:cardField];
    self.cardField = cardField;
    
    //rightView
    UIView* baseRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kImageSize * 2, kImageSize)];
    cardField.rightViewMode = UITextFieldViewModeAlways;
    
    UIImageView* scanView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_swipeCard_small_btn"]];
    scanView.userInteractionEnabled = YES;
    scanView.contentMode = UIViewContentModeCenter;
    scanView.frame = CGRectMake(kImageSize, 0, kImageSize, kImageSize);
    [baseRightView addSubview:scanView];
    UITapGestureRecognizer* scanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [scanView addGestureRecognizer:scanTap];
    cardField.rightView = baseRightView;
    
    //今天按钮
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMaxX(cardField.frame) + kLeftWidth, 0, kButtonWidth, kCommonHeight);
    button.centerY = kBackViewHeight / 2;
    button.backgroundColor = kBlue0A59C2;
    button.layer.cornerRadius = 3;
    [button setTitle:kLocalized(@"GYHS_Point_Today") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:button];
    
    //开始日期
    GYHSCunsumeTextField* begainField = [[GYHSCunsumeTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame) + kLeftWidth, 0, kTimeFieldWidth, kCommonHeight)];
    begainField.centerY = kBackViewHeight / 2;
    begainField.placeholder = kLocalized(@"GYHS_Point_Start_Date");
    begainField.layer.borderWidth = 1;
    begainField.layer.borderColor = kDefaultVCBackgroundColor.CGColor;
    [self setRightViewWithTextField:begainField imageName:@"gyhs_point_date"];
    begainField.delegate = self;
    UITapGestureRecognizer* tapBegin = [[UITapGestureRecognizer alloc] init];
    tapBegin.delegate = self;
    [begainField addGestureRecognizer:tapBegin];
    [backview addSubview:begainField];
    self.begainField = begainField;
    
    //结束日期
    GYHSCunsumeTextField* endTextfield = [[GYHSCunsumeTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(begainField.frame) + kLeftWidth, 0, kTimeFieldWidth, kCommonHeight)];
    endTextfield.centerY = kBackViewHeight / 2;
    endTextfield.placeholder = kLocalized(@"GYHS_Point_End_Date");
    endTextfield.layer.borderWidth = 1;
    endTextfield.layer.borderColor = kDefaultVCBackgroundColor.CGColor;
    [self setRightViewWithTextField:endTextfield imageName:@"gyhs_point_date"];
    endTextfield.delegate = self;
    UITapGestureRecognizer* tapEnd = [[UITapGestureRecognizer alloc] init];
    tapEnd.delegate = self;
    [endTextfield addGestureRecognizer:tapEnd];
    [backview addSubview:endTextfield];
    self.endTextfield = endTextfield;
    
    //查询按钮
    UIButton* checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(endTextfield.frame) + kLeftWidth, 0, kButtonWidth, kCommonHeight)];
    checkBtn.centerY = kBackViewHeight / 2;
    [checkBtn setTitle:kLocalized(@"GYHS_Point_Check") forState:UIControlStateNormal];
    [checkBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [checkBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [checkBtn setImage:[UIImage imageNamed:@"gyhs_point_check"] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:checkBtn];
    
    backview.width = CGRectGetMaxX(checkBtn.frame) + 2 * kLeftWidth;
    backview.centerX = self.centerX;
}

#pragma mark - tap
- (void)tapAction:(UITapGestureRecognizer*)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(getScanWithNumber)]) {
        [_delegate getScanWithNumber];
    }
}

#pragma mark - 今天
- (void)click
{
    [self endEditing:YES];
    NSDate* nowDate = [NSDate date];
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString* locationString = [dateformatter stringFromDate:nowDate];
    self.begainField.text = locationString;
    self.endTextfield.text = locationString;
}

#pragma mark - 设置rightView
- (void)setRightViewWithTextField:(GYHSCunsumeTextField*)textField imageName:(NSString*)imageName
{

    UIImageView* rightView = [[UIImageView alloc] init];
    rightView.image = [UIImage imageNamed:imageName];
    rightView.size = CGSizeMake(kImageSize, kImageSize);
    rightView.contentMode = UIViewContentModeCenter;
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField == self.begainField || textField == self.endTextfield) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if (textField == self.cardField) {
        NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
        NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 11) {
            if (![GYUtils isHSCardNo:[toBeString substringToIndex:11]]) {
                [textField tipWithContent:kLocalized(@"GYHS_Point_Input_Number_Error_Tip") animated:YES];
            }else{
              [textField resignFirstResponder];
            }
            return NO;
        }
        return YES;
        
    } else {
    
        return YES;
    }
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    [self endEditing:YES];
    if ([touch.view isKindOfClass:[UITextField class]]) {
    
        UITextField* textField = (UITextField*)touch.view;
        if (textField == self.begainField) {
            GYDatePickView* dateView = [[GYDatePickView alloc] initWithDatePickViewType:DatePickViewTypeDate];
            [dateView show];
            @weakify(self);
            dateView.dateBlcok = ^(NSString* dateString) {
                @strongify(self);
                NSString* string = [GYHSPublicMethod compareWithLimitString:dateString days:kDateInterval];
                BOOL isRight = [GYHSPublicMethod compareWithDateString:string ohterDateString:self.endTextfield.text];
                if (isRight) {
                    self.begainField.text = string;
                }else{
                    self.begainField.text = self.endTextfield.text;
                }

            };
        }
        if (textField == self.endTextfield) {
            GYDatePickView* dateEndView = [[GYDatePickView alloc] initWithDatePickViewType:DatePickViewTypeDate];
            [dateEndView show];
            @weakify(self);
            dateEndView.dateBlcok = ^(NSString* dateString) {
                @strongify(self);
                NSString* string = [GYHSPublicMethod compareWithLimitString:dateString days:kDateInterval];
                BOOL isRight = [GYHSPublicMethod compareWithDateString:self.begainField.text ohterDateString:string];
                if (isRight) {
                    self.endTextfield.text = string;
                }else{
                    self.endTextfield.text = self.begainField.text;
                }

            };
        }
    }
    return NO;
}

#pragma mark - 查询
- (void)checkClick
{
    [self endEditing:YES];
    if ([self isDataAllright]) {
        if (_delegate && [_delegate respondsToSelector:@selector(checkWithPerNo:startDate:endDate:)]) {
            [_delegate checkWithPerNo:self.cardField.text startDate:self.begainField.text endDate:self.endTextfield.text];
        }
    }
}

#pragma mark - 数据是否正确
- (BOOL)isDataAllright
{
    if (![GYUtils isHSCardNo:self.cardField.text]) {
        [self.cardField tipWithContent:kLocalized(@"GYHS_Point_Input_Number_Error_Tip") animated:YES];
        return NO;
    }
    if (!self.begainField.text.length) {
        [self.begainField tipWithContent:kLocalized(@"GYHS_Point_Select_Start_Date") animated:YES];
        return NO ;
    }
    return YES;
}

@end
