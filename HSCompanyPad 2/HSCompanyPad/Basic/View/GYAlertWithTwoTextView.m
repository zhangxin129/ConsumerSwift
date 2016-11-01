//
//  GYAlertWithTwoTextView.m
//
//  Created by apple on 16/8/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYAlertWithTwoTextView.h"

#define Alertwidth 325.0f
#define Alertheigth 258.0f
#define XWtitlegap 50.0f
#define XWtitleofheigth 25.0f
#define XWdoublebuttonWidth 70.0f
//        双个按钮的宽度
#define XWbuttonHeigth 33.0f
//        按钮的高度

@interface GYAlertWithTwoTextView()<UITextFieldDelegate>

@property (nonatomic, weak) UIImageView* backImageView;
@property (nonatomic, copy) GYAlertBlock block;
@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *userNameTitleLabel;
@property (nonatomic, strong) UILabel *passWordTitleLabel;

@property (nonatomic, strong) UITextField *passWordTextField;

@property (nonatomic, strong) UILabel *userNameLable;
@property (nonatomic, strong) UILabel *passWordLable;
@property (nonatomic, strong) UIView *backimageView;

@end

@implementation GYAlertWithTwoTextView

+ (CGFloat)alertWidth
{
    return Alertwidth;
}

+ (CGFloat)alertHeight
{
    return Alertheigth;
}

- (id)initWithTitle:(NSString *)title userNameTF:(NSString *)userName passWordTF:(NSString *)passWord leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle{
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView* hsIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycom_blueTop"]];
        hsIconImageView.frame = CGRectMake(0, 0, Alertwidth, 36);
        hsIconImageView.userInteractionEnabled = YES;
        hsIconImageView.multipleTouchEnabled = YES;
        hsIconImageView.backgroundColor = kWhiteFFFFFF;
        [self addSubview:hsIconImageView];
        
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(36, 0, 100, 30);
        titleLabel.text = title;
        titleLabel.textColor = kWhiteFFFFFF;
        titleLabel.font = kFont28;
        [hsIconImageView addSubview:titleLabel];

        
        UIButton* forkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        forkButton.frame = CGRectMake(Alertwidth - 36, 2, 26, 26);
        forkButton.contentMode = UIViewContentModeCenter;
        forkButton.backgroundColor = [UIColor clearColor];
        [forkButton setImage:[UIImage imageNamed:@"gycom_forkButton"] forState:UIControlStateNormal];
        [forkButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [hsIconImageView addSubview:forkButton];
        
        self.userNameTitleLabel=[[UILabel alloc] init];
        self.userNameTitleLabel.frame = CGRectMake(20, XWtitleofheigth + 35, 130, 30);
        self.userNameTitleLabel.text = userName;
        self.userNameTitleLabel.textColor = kGray333333;
        self.userNameTitleLabel.font = kFont32;
        self.userNameLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.userNameTitleLabel];

        self.userNameTextField = [[UITextField alloc] init];
        self.userNameTextField.frame = CGRectMake(20 + 130, XWtitleofheigth + 30, 150, 40);
        self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.userNameTextField.layer.borderColor = kGrayDDDDDD.CGColor;
        self.userNameTextField.layer.borderWidth = 1.0f;
        self.userNameTextField.placeholder = kLocalized(@"输入绑定互生卡号");
        self.userNameTextField.delegate = self;
        self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* userNameLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(10), kDeviceProportion(40))];
        self.userNameTextField.leftView = userNameLeftView;
        [self addSubview:self.userNameTextField];


        self.passWordTitleLabel =[[UILabel alloc] init];
        self.passWordTitleLabel.frame = CGRectMake(20, XWtitleofheigth + 35 + 40 + 20, 130, 30);
        self.passWordTitleLabel.text = passWord;
        self.passWordTitleLabel.textColor = kGray333333;
        self.passWordTitleLabel.font = kFont32;
        [self addSubview:self.passWordTitleLabel];

        self.passWordTextField = [[UITextField alloc] init];
         self.passWordTextField.frame = CGRectMake(20 + 130, XWtitleofheigth + 30 + 40 + 20, 150, 40);
        self.passWordTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.passWordTextField.layer.borderColor = kGrayDDDDDD.CGColor;
        self.passWordTextField.layer.borderWidth = 1.0f;
        self.passWordTextField.delegate = self;
        self.passWordTextField.secureTextEntry = YES;
        self.passWordTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* passWordLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(10), kDeviceProportion(40))];
        self.passWordTextField.leftView = passWordLeftView;
        [self addSubview:self.passWordTextField];

        _leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftbtn.frame = CGRectMake(75, Alertheigth - 35 - 33, 70, 33);
        _leftbtn.backgroundColor = [UIColor colorWithHexString:@"e50012"];
        [_leftbtn setTitle:leftTitle forState:UIControlStateNormal];
        _leftbtn.titleLabel.font = kFont32;
        _leftbtn.layer.cornerRadius = 6;
        _leftbtn.layer.borderWidth = 1;
        _leftbtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_leftbtn addTarget:self action:@selector(leftbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftbtn];

        
        _rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightbtn.frame = CGRectMake(75 + 70 + 15, Alertheigth - 35 - 33, 90, 33);
        _rightbtn.backgroundColor = [UIColor colorWithHexString:@"868695"];
        [_rightbtn setTitle:rigthTitle forState:UIControlStateNormal];
        _rightbtn.titleLabel.font = kFont32;
        _rightbtn.layer.cornerRadius = 6;
        _rightbtn.layer.borderWidth = 1;
        _rightbtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_rightbtn addTarget:self action:@selector(rightbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightbtn];
        
        self.alertTitleLabel.text = title;
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}


- (void)click{
    [self removeFromSuperview];
}
- (void)leftbtnclicked:(UIButton *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(transAlertView:CardNum:Password:)]) {
        [self.delegate transAlertView:self CardNum:self.userNameTextField.text Password:self.passWordTextField.text];
    }
}

- (void)rightbtnclicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(transPassword:) ]) {
        [self.delegate transPassword:self.passWordTextField.text];
    }

    [self removeFromSuperview];
}
- (void)show
{   //获取第一响应视图视图
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - Alertwidth) * 0.5-30, (CGRectGetHeight(topVC.view.bounds) - Alertheigth) * 0.5-20, Alertwidth, Alertheigth);
    self.alpha=0;
    [topVC.view addSubview:self];
}


- (UIViewController *)appRootViewController
{
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [self.backimageView removeFromSuperview];
    self.backimageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - Alertwidth) * 0.5+30, (CGRectGetHeight(topVC.view.bounds) - Alertheigth) * 0.5-30, Alertwidth, Alertheigth);
    
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        self.alpha=0;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}
//添加新视图时调用（在一个子视图将要被添加到另一个视图的时候发送此消息）
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    //     获取根控制器
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backimageView) {
        self.backimageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backimageView.backgroundColor = [UIColor lightGrayColor];
        self.backimageView.alpha = 0.6f;
        self.backimageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    //    加载背景背景图,防止重复点击
    [topVC.view addSubview:self.backimageView];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - Alertwidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - Alertheigth) * 0.5, Alertwidth, Alertheigth);
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = afterFrame;
        self.alpha=0.9;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    unsigned long len = textField.text.length + string.length;
    if (textField == self.userNameTextField) {
        if(len > 11)
        {
            
            [textField resignFirstResponder];
            
            return NO;
        }
        
        if (len < 11) {
            
        }
        
        return YES;
    }
    if (textField == self.passWordTextField) {
        if (len > 6) {
            
            [textField resignFirstResponder];
            
            return NO;
        }
        if (len < 6) {
            
        }
        return YES;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.userNameTextField) {
        if (textField.text.length < 11) {
            [textField tipWithContent:kLocalized(@"GYBasic_PleaseEnterTheCorrectHSNumber") animated:YES];
        }
    }else if (textField.text.length < 6){
        [textField tipWithContent:kLocalized(@"GYBasic_PleaseEnterTheCorrectLoginPassword") animated:YES];
    }
}


@end
