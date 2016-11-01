//
//  GYHESCCartAlertView.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHESCCartAlertView.h"

@interface GYHESCCartAlertView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel* titleTagLabel;

@end

@implementation GYHESCCartAlertView

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
   }
 */

- (void)awakeFromNib
{
    [self.numberTextField addTarget:self action:@selector(setCountTextFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    self.numberTextField.delegate = self;
    self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubLayerForLabel];
}

- (void)setCountTextFieldDidChanged
{
    if ([self.numberTextField.text integerValue] > self.maxNumber) {
        [self setAlertTip:self.maxNumber tipContent:[NSString stringWithFormat:kLocalized(@"HE_SC_CartMaxGoodsNumber"), self.maxNumber]];
    }
    else if ([self.numberTextField.text integerValue] < 1 && self.numberTextField.text && self.numberTextField.text.length > 0) {
        [self setAlertTip:1 tipContent:kLocalized(@"HE_SC_CartMinGoodsNumber")];
    }
}

- (IBAction)addButtonClick:(UIButton*)sender
{
    NSInteger count = kSaftToNSInteger(self.numberTextField.text);
    count++;
    if (count > self.maxNumber) {
        [self setAlertTip:self.maxNumber tipContent:[NSString stringWithFormat:kLocalized(@"HE_SC_CartMaxGoodsNumber"), self.maxNumber]];
    }
    else {
        self.numberTextField.text = [NSString stringWithFormat:@"%ld", count];
    }
}

- (IBAction)subtractButtonClick:(UIButton*)sender
{
    NSInteger count = kSaftToNSInteger(self.numberTextField.text);
    count--;
    if (count < 1) {
        [self setAlertTip:1 tipContent:kLocalized(@"HE_SC_CartMinGoodsNumber")];
    }
    else {
        self.numberTextField.text = [NSString stringWithFormat:@"%ld", count];
    }
}

- (IBAction)cancleButtonClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(cancleButtonClicked)]) {
        [self.delegate cancleButtonClicked];
    }
}

- (IBAction)confirmButtonClick:(UIButton*)sender
{
    if ([self.numberTextField.text integerValue] < 1) {
        [self setAlertTip:1 tipContent:kLocalized(@"HE_SC_CartMinGoodsNumber")];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(confirmButtonClicked)]) {
            [self.delegate confirmButtonClicked];
        }
    }
}

//弹出提示框
- (void)setAlertTip:(NSInteger)number tipContent:(NSString*)tipString
{
    UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
    tipLabel.backgroundColor = [UIColor blackColor];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5 + 8);
    [self addSubview:tipLabel];
    tipLabel.text = tipString;
    self.numberTextField.text = [NSString stringWithFormat:@"%ld", number];
    [UIView animateWithDuration:2 animations:^{
        tipLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [tipLabel removeFromSuperview];
    }]; //两秒后移除
}

- (void)addSubLayerForLabel
{

    CALayer* topBorder = [CALayer layer];
    float width = self.numberTextField.frame.size.width;
    topBorder.frame = CGRectMake(0, 0, width, 1 / [UIScreen mainScreen].scale);
    topBorder.backgroundColor = kCorlorFromRGBA(201, 202, 202, 1).CGColor;
    [self.numberTextField.layer addSublayer:topBorder];

    CALayer* bottomBorder = [CALayer layer];
    float height = self.numberTextField.frame.size.height - 1 / [UIScreen mainScreen].scale;
    bottomBorder.frame = CGRectMake(0, height, width, 1 / [UIScreen mainScreen].scale);
    bottomBorder.backgroundColor = kCorlorFromRGBA(201, 202, 202, 1).CGColor;
    [self.numberTextField.layer addSublayer:bottomBorder];
}

#pragma mark - uiTextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if ([textField.text integerValue] < 1) {
        [self setAlertTip:1 tipContent:kLocalized(@"HE_SC_CartMinGoodsNumber")];
    }
}

//解除编辑状态
- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
