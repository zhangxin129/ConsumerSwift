//
//  GYPasswordKeyboardView.m
//  GYText
//
//  Created by lizp on 16/9/5.
//  Copyright © 2016年 Apple05. All rights reserved.
//

#define kKeyboardButtonTag 800

#import "GYPasswordKeyboardView.h"
#import "GYPasswordTextFiled.h"

@interface GYPasswordKeyboardView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel* titleLabel; //标题
@property (nonatomic, strong) GYPasswordTextFiled* textFiled; //输入文本框
@property (nonatomic, strong) UIButton* cancelButton; //取消
@property (nonatomic, strong) NSMutableArray* titleArray; //数字0~9
@property (nonatomic, strong) UIColor* titleColor; //文字颜色
@property (nonatomic, strong) UIFont* font; //字体
@property (nonatomic, strong) UIColor* numberBackgroundColor; //按钮块的背景颜色
@property (nonatomic, weak) UITextField* inputTextField; //传给来的TextFeild
@property (nonatomic, strong) UIView* backgroundView; //背景（交易类型才有）

@end

@implementation GYPasswordKeyboardView

- (void)pop:(UIView*)popView
{
    if (self.style == GYPasswordKeyboardStyleLogin) {
        if (self.inputTextField != nil) {
            if (popView) {
                [popView addSubview:self];
            }
            else {
                [self.inputView.superview addSubview:self];
            }
            [self setUp];
        }
        return;
    }

    if (popView) {
        [popView addSubview:self];
        [self customInit];
        [self fadeIn];
    }
    else {
        return;
    }
}

- (void)dismiss
{

    [self fadeOut];
}

#pragma mark---animation methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [self.textFiled becomeFirstResponder];
    
    [UIView animateWithDuration:0 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished){

    }];
}

- (void)fadeOut
{
    [self endEditing:YES];
    [UIView animateWithDuration:0 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)customInit
{

    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.userInteractionEnabled = YES;
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backgroundView];

    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;

    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:kLocalized(@"GY_Keyboard_Cancel_Or_Back") forState:UIControlStateNormal];
    if (self.colorType == GYPasswordKeyboardCommitColorTypeRed) {
        [self.cancelButton setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    }
    else {
        [self.cancelButton setTitleColor:UIColorFromRGB(0x1d7dd6) forState:UIControlStateNormal];
    }
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:14 * self.bounds.size.width / [UIScreen mainScreen].bounds.size.width];
    self.cancelButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:self.cancelButton];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18 * self.bounds.size.width / [UIScreen mainScreen].bounds.size.width];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = kLocalized(@"GY_Keyboard_Input_Trade_Password");
    [self.backgroundView addSubview:self.titleLabel];

    self.textFiled = [[GYPasswordTextFiled alloc] init];
    self.textFiled.backgroundColor = [UIColor whiteColor];
    self.textFiled.layer.masksToBounds = YES;
    self.textFiled.layer.borderColor = [UIColor grayColor].CGColor;
    self.textFiled.layer.borderWidth = 1;
    self.textFiled.layer.cornerRadius = 5;
    self.textFiled.secureTextEntry = YES;
    self.textFiled.delegate = self;
    self.textFiled.tintColor = [UIColor clearColor]; //看不到光标
    self.textFiled.textColor = [UIColor clearColor]; //看不到输入内容
    self.textFiled.font = [UIFont systemFontOfSize:30];
    self.textFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.textFiled.pattern = [NSString stringWithFormat:@"^\\d{%li}$", (long)kPasswordLength];
    [self.backgroundView addSubview:self.textFiled];
    self.textFiled.inputView = [[UIView alloc] initWithFrame:CGRectZero];

    CGFloat offsetX = 10;
    CGFloat offsetY = 10;
    self.titleLabel.frame = CGRectMake(offsetX, offsetY, self.bounds.size.width - 2 * offsetX, 21);
    offsetY += self.titleLabel.frame.size.height + 10;
    self.textFiled.frame = CGRectMake(offsetX, offsetY, self.bounds.size.width - 2 * offsetX, 35);
    self.cancelButton.frame = CGRectMake(self.bounds.size.width - 70 - 10, 10, 70, 20);
    [self setUp];
}

//取消交易操作
- (void)cancelButtonClick
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelClick)]) {
        [self.delegate cancelClick];
    }
}

- (void)textFiledEdingChanged
{
    NSInteger length = self.textFiled.text.length;
    NSLog(@"lenght=%li", (long)length);
    if (length >= kPasswordLength) {
        self.textFiled.text = [self.textFiled.text substringToIndex:kPasswordLength];
    }
    [self tradePwdInputViewChange];
}

- (void)tradePwdInputViewChange
{

    NSInteger length = self.textFiled.text.length;
    for (NSInteger i = 0; i < kPasswordLength; i++) {
        UILabel* dotLabel = (UILabel*)[self.textFiled viewWithTag:kDotTag + i];
        if (dotLabel) {
            dotLabel.hidden = length <= i;
        }
    }
    [self.textFiled sendActionsForControlEvents:UIControlEventValueChanged];
}

/**
 *  初始设置
 */
- (void)setUp
{

    if (!self.numberBackgroundColor) {
        self.numberBackgroundColor = UIColorFromRGB(0xffffff);
    }

    if (!self.titleColor) {
        self.titleColor = UIColorFromRGB(0x666666);
    }

    for (NSInteger i = 0; i < 12; i++) {
        UIView* view = [self viewWithTag:i + kKeyboardButtonTag];
        [view removeFromSuperview];
    }

    self.titleArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray* numbers = [[NSMutableArray alloc] initWithArray:@[ @"1", @"2", @"3", @"4", @"5", @"6", @"0", @"7", @"8", @"9" ]];
    while (numbers.count) {
        NSString* str;
        if(self.isSecurity) {
            str = [NSString stringWithFormat:@"%@",numbers[arc4random()%(numbers.count)]];
        }else {
            str = numbers[0];
        }
        [self.titleArray addObject:str];
        [numbers removeObject:str];
    }

    CGFloat alpha = 1;
    for (int i = 0; i < 12; i++) {
        UIButton* btn = [[UIButton alloc] init];

        btn.tag = kKeyboardButtonTag + i;
        btn.alpha = alpha;
        if (self.font) {
            btn.titleLabel.font = self.font;
        }
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1]] forState:UIControlStateHighlighted];
        NSString* titleStr;
        switch (i) {
        case 11:
            if (self.type == GYPasswordKeyboardReturnTypeLogin) {
                titleStr = kLocalized(@"GY_Keyboard_Login");
            }
            else if (self.type == GYPasswordKeyboardReturnTypeCommit) {
                titleStr = kLocalized(@"GY_Keyboard_Commit");
            }
            else if (self.type == GYPasswordKeyboardReturnTypeConfirm) {
                titleStr = kLocalized(@"GY_Keyboard_Confirm");
            }

            [btn setTitle:titleStr forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(finishedBtn) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];

            if (self.colorType == GYPasswordKeyboardCommitColorTypeRed) {
                btn.backgroundColor = kNavigationBarColor;
            }
            else if (self.colorType == GYPasswordKeyboardCommitColorTypeOrange) {
                btn.backgroundColor = kCorlorFromRGBA(249, 125, 0, 1);
            }
            else {
                btn.backgroundColor = UIColorFromRGB(0x1d7dd6);
            }
            break;
        case 3:
            titleStr = @"";
            [btn addTarget:self action:@selector(deleteBtn) forControlEvents:UIControlEventTouchUpInside];
            [btn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressGesture)]];
            [btn setImage:[UIImage imageNamed:@"gyhs_keyboard_delete"] forState:UIControlStateNormal];
            [btn setBackgroundColor:self.numberBackgroundColor];
            break;
        default:
            [btn setBackgroundColor:self.numberBackgroundColor];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

            break;
        }

        if (!(i == 3 || i == 11)) {
            if(self.isSecurity) {
                [btn setTitle:_titleArray[0] forState:UIControlStateNormal];
            }else {
                [btn setTitle:_titleArray[0] forState:UIControlStateNormal];
            }

            [_titleArray removeObjectAtIndex:0];
        }

        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;

        CGFloat headerH;
        CGFloat offsetY;
        //头部密码部分 最小高度为85
        if (self.style) {
            if (height / 3.0 < 85) {
                headerH = (height - 85) / 3.0;
                offsetY = 85;
            }
            else {
                headerH = height / 3.0 * 2 / 3.0;
                offsetY = height / 3.0;
            }
        }
        else {
            headerH = height / 3.0;
            offsetY = 0;
        }

        CGFloat btnW = (width) / 4;
        CGFloat btnH = headerH;
        CGFloat btnY;
        CGFloat btnX = (i % 4) * btnW;

        if (self.style == GYPasswordKeyboardStyleLogin) {
            btnY = (i / 4) * btnH;
            [self addSubview:btn];
        }
        else {
            btnY = (i / 4) * btnH + offsetY;
            [self.backgroundView addSubview:btn];
        }
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

- (void)settingInputView:(UITextField*)inputView
{

    self.inputTextField = inputView;
    inputView.inputView = [[UIView alloc] initWithFrame:CGRectZero];
}

/**
 *  删除
 */
- (void)deleteBtn
{

    if (self.style == GYPasswordKeyboardStyleLogin) {
        if (self.inputTextField.text.length != 0) {
            self.inputTextField.text = [self.inputTextField.text substringToIndex:self.inputTextField.text.length - 1];
        }
    }
    else if (self.style == GYPasswordKeyboardStyleTrading) {
        if (self.textFiled.text.length != 0) {
            self.textFiled.text = [self.textFiled.text substringToIndex:self.textFiled.text.length - 1];
            [self textFiledEdingChanged];
        }
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(textFiledEdingChanged:)]) {
        if (self.style == GYPasswordKeyboardStyleTrading) {
            [self.delegate textFiledEdingChanged:self.textFiled];
        }
        else if (self.style == GYPasswordKeyboardStyleLogin) {
            [self.delegate textFiledEdingChanged:self.inputTextField];
        }
    }
}

/**
 *  完成
 */
- (void)finishedBtn
{
    NSString* password;
    if (self.style == GYPasswordKeyboardStyleLogin) {
        [self.inputTextField endEditing:YES];
        password = self.inputTextField.text;
    }
    else if (self.style == GYPasswordKeyboardStyleTrading) {
        [self.textFiled endEditing:YES];
        password = self.textFiled.text;
    }

    if ([self.delegate respondsToSelector:@selector(returnPasswordKeyboard:style:type:password:)]) {
        __weak typeof(self) weakSelf = self;
        [self.delegate returnPasswordKeyboard:weakSelf style:self.style type:self.type password:password];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(returnCommitBtn:)]) {
        UIView* view;
        if (self.style == GYPasswordKeyboardStyleLogin) {
            view = [self viewWithTag:11 + kKeyboardButtonTag];
        }
        else {
            view = [self.backgroundView viewWithTag:11 + kKeyboardButtonTag];
        }
        __weak UIButton* btn = (UIButton*)view;
        [self.delegate returnCommitBtn:btn];
    }
}

/**
 *  点击输入
 *
 *  @param btn
 */
- (void)btnClick:(UIButton*)btn
{

    if (self.style == GYPasswordKeyboardStyleLogin) {
        self.inputTextField.text = [NSString stringWithFormat:@"%@%@", self.inputTextField.text, btn.titleLabel.text];
    }
    else if (self.style == GYPasswordKeyboardStyleTrading) {
        self.textFiled.text = [NSString stringWithFormat:@"%@%@", self.textFiled.text, btn.titleLabel.text];
        [self textFiledEdingChanged];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(textFiledEdingChanged:)]) {
        if (self.style == GYPasswordKeyboardStyleTrading) {
            [self.delegate textFiledEdingChanged:self.textFiled];
        }
        else if (self.style == GYPasswordKeyboardStyleLogin) {
            [self.delegate textFiledEdingChanged:self.inputTextField];
        }
    }
}
/**
 *  长按删除，全部删除
 */
- (void)longpressGesture
{

    if (self.style == GYPasswordKeyboardStyleLogin) {
        self.inputTextField.text = nil;
    }
    else if (self.style == GYPasswordKeyboardStyleTrading) {
        self.textFiled.text = nil;
        [self textFiledEdingChanged];
    }

}

/**
 *  绘制的图
 */
- (UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - get or set
- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
}

- (void)setStyle:(GYPasswordKeyboardStyle)style
{
    if (style == GYPasswordKeyboardStyleTrading) {
        _type = GYPasswordKeyboardReturnTypeCommit;
//        _isSecurity = YES;//当为交易密码类型时，强制设置键盘数字错乱
    }
    _style = style;
}

- (void)setType:(GYPasswordKeyboardReturnType)type
{
    if (_style == GYPasswordKeyboardStyleTrading) {
        _type = GYPasswordKeyboardReturnTypeCommit;
//        _isSecurity = YES;//当为交易密码类型时，强制设置键盘数字错乱
    }
    else if (_style == GYPasswordKeyboardStyleLogin) {
        _type = type;
    }

    UIButton* btn = (UIButton*)[self viewWithTag:kKeyboardButtonTag + 11];
    if (!btn) {
        return;
    }
    if (_type == GYPasswordKeyboardReturnTypeConfirm) {
        [btn setTitle:kLocalized(@"GY_Keyboard_Confirm") forState:UIControlStateNormal];
    }
    else if (_type == GYPasswordKeyboardReturnTypeCommit) {
        [btn setTitle:kLocalized(@"GY_Keyboard_Commit") forState:UIControlStateNormal];
    }
    else if (_type == GYPasswordKeyboardReturnTypeLogin) {
        [btn setTitle:kLocalized(@"GY_Keyboard_Login") forState:UIControlStateNormal];
    }
}

//当为交易密码类型时，强制设置键盘数字错乱
//- (void)setIsSecurity:(BOOL)isSecurity
//{
//
//    if(_style == GYPasswordKeyboardStyleTrading) {
//        _type = GYPasswordKeyboardReturnTypeCommit;
//        _isSecurity = YES;
//    }else if(_style == GYPasswordKeyboardStyleLogin) {
//        _isSecurity = isSecurity;
//    }
//}



@end
