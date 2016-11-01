//
//  GYAlertWithAddFoodFieldView.m
//  GYRestaurant
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAlertWithAddFoodFieldView.h"
#import "GYSinglePointViewController.h"

#define Alertwidth 500.0f
#define Alertheigth 300.0f
#define XWtitlegap 50.0f
#define XWtitleofheigth 25.0f
#define XWdoublebuttonWidth 100.0f
//        双个按钮的宽度
#define XWbuttonHeigth 50.0f
//        按钮的高度
#define XWbuttonbttomgap 20.0f
//        设置按钮距离底部的边距

@interface GYAlertWithAddFoodFieldView ()<UITextFieldDelegate>
{
    BOOL _leftLeave;
}

@property (nonatomic, copy) NSString *deposit;//用来传递订金

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *ramadhinLabel;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UIButton *leftbtn;
@property (nonatomic, strong) UIButton *rightbtn;
@property (nonatomic, strong) UIView *backimageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *tipsLable;
@property (nonatomic, strong) UILabel *cancelLable;
@property (nonatomic, strong) UITextField *cancelTF;
@property (nonatomic, strong) UILabel *receivedDepositLable;
@property (nonatomic, strong) UILabel *depositLable;
@property (nonatomic, strong) UIButton *hsNumbtn;
@property (nonatomic, strong) UIButton *phoneNumbtn;
@property (nonatomic, strong) UILabel *hsNumLable;
@property (nonatomic, strong) UILabel *phoneNumLable;
@property (nonatomic, strong) UILabel *returnDepositLable;
@property (nonatomic, strong) UILabel *reDepositLable;
@property (nonatomic, strong) GYSinglePointViewController *ctl;
@end

@implementation GYAlertWithAddFoodFieldView

+ (CGFloat)alertWidth
{
    return Alertwidth;
}

+ (CGFloat)alertHeight
{
    return Alertheigth;
}
-(id)initWithTitle:(NSString *)title numberTextFieldName:(NSString *)numberr leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle{
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, XWtitlegap, Alertwidth, XWtitleofheigth)];
        self.alertTitleLabel.font = [UIFont systemFontOfSize:18];
        self.alertTitleLabel.textColor=[UIColor blackColor];
        self.alertTitleLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.alertTitleLabel];
        
        self.lineView=[[UIView alloc] initWithFrame:CGRectMake(0, XWtitleofheigth+XWtitlegap+10, Alertwidth, 1)];
        self.lineView.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:self.lineView];
        
        CGFloat contentLabelWidth = Alertwidth - 220;

        self.hsNumbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.hsNumbtn.frame=CGRectMake(10, CGRectGetMaxY(self.lineView.frame) + 20, 20, 40);
        [self.hsNumbtn setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
        [self.hsNumbtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [self.hsNumbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.hsNumbtn.tag = 100;
        [self addSubview:self.hsNumbtn];
        
        self.hsNumLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hsNumbtn.frame)+5, CGRectGetMaxY(self.lineView.frame) + 20, 60, 40)];
        self.hsNumLable.text = kLocalized(@"HSNumber");
        self.hsNumLable.textColor=[UIColor blackColor];
        [self addSubview:self.hsNumLable];
        
        self.phoneNumbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.phoneNumbtn.frame=CGRectMake(CGRectGetMaxX(self.hsNumLable.frame) + 10, CGRectGetMaxY(self.lineView.frame) + 20, 20, 40);
        [self.phoneNumbtn setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
        [self.phoneNumbtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [self.phoneNumbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.phoneNumbtn.tag = 101;
        [self addSubview:self.phoneNumbtn];
        
        self.phoneNumLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneNumbtn.frame)+5, CGRectGetMaxY(self.lineView.frame) + 20, 80, 40)];
        self.phoneNumLable.text=kLocalized(@"PhoneNumber:");
        self.phoneNumLable.textColor=[UIColor blackColor];
        [self addSubview:self.phoneNumLable];
        self.hsNumbtn.selected = YES;
       

        self.ramadhinTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(self.lineView.frame) + 20, contentLabelWidth - 100, 40)];
        
        self.ramadhinTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.ramadhinTextField.borderStyle = UITextBorderStyleLine;
        if (self.hsNumbtn.selected == YES) {
            self.ramadhinTextField.placeholder = kLocalized(@"PleaseEnterHSNumber");
            self.returnStatusStr = @"2";
            self.isCardStr = @"1";
        }else if (self.phoneNumbtn.selected == YES){
            self.ramadhinTextField.placeholder = kLocalized(@"PleaseEnterPhoneNumber");
            self.returnStatusStr = @"1";
            self.isCardStr = @"0";
        }
        
        self.ramadhinTextField.delegate = self;
        [self addSubview:self.ramadhinTextField];
        
        if (numberr) {
            
            self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(self.ramadhinTextField.frame) + 20, 140, 40)];
            self.numberLabel.textAlignment = NSTextAlignmentRight;
            self.numberLabel.text = numberr;
            
            [self addSubview:self.numberLabel];
            self.numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numberLabel.frame), CGRectGetMaxY(self.ramadhinTextField.frame) + 20, contentLabelWidth - 100, 40)];
            self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.numberTextField.borderStyle = UITextBorderStyleLine;
            self.numberTextField.secureTextEntry = YES;
            self.numberTextField.placeholder = kLocalized(@"PleaseEnterLoginPassword");
            self.numberTextField.delegate = self;
            [self addSubview:self.numberTextField];
        }
        
        
        CGRect leftbtnFrame;
        CGRect rightbtnFrame;
        
        leftbtnFrame = CGRectMake(100, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth, 100, XWbuttonHeigth);
        rightbtnFrame = CGRectMake(300, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth, 100, XWbuttonHeigth);
        self.leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.leftbtn.frame = leftbtnFrame;
        self.rightbtn.frame = rightbtnFrame;
        
        [self.rightbtn setBackgroundColor:[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0]];
        [self.leftbtn setBackgroundColor:[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0]];
        [self.rightbtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftbtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftbtn.titleLabel.font = self.rightbtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.leftbtn setTitleColor:[UIColor colorWithRed:97/255.0 green:96/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.rightbtn setTitleColor:[UIColor colorWithRed:97/255.0 green:96/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.leftbtn addTarget:self action:@selector(leftbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightbtn addTarget:self action:@selector(rightbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftbtn.layer.masksToBounds = self.rightbtn.layer.masksToBounds = YES;
        self.leftbtn.layer.cornerRadius = self.rightbtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftbtn];
        [self addSubview:self.rightbtn];
        self.alertTitleLabel.text = title;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;



}

-(void)btnAction:(UIButton *)btn{
    self.hsNumbtn.selected = NO;
    self.phoneNumbtn.selected = NO;
    if (btn.tag == 100) {
        self.returnStatusStr = @"2";
        self.isCardStr = @"1";
      //  self.reDepositLable.text = self.deposit;
        self.ramadhinTextField.placeholder = kLocalized(@"PleaseEnterHSNumber");
        self.hsNumbtn.selected = YES;
    }
    if (btn.tag == 101) {
        self.returnStatusStr = @"1";
        self.isCardStr = @"0";
       // self.reDepositLable.text=@"0.00";
        self.ramadhinTextField.placeholder = kLocalized(@"PleaseEnterPhoneNumber");
        self.phoneNumbtn.selected = YES;
    }
}

- (id)initWithTitle:(NSString *)title
ramadhinTextFieldName:(NSString *)amadhin
numberTextFieldName:(NSString*)numberr
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, XWtitlegap, Alertwidth, XWtitleofheigth)];
        self.alertTitleLabel.font = [UIFont systemFontOfSize:18];
        self.alertTitleLabel.textColor=[UIColor blackColor];
        self.alertTitleLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.alertTitleLabel];
        
        self.lineView=[[UIView alloc] initWithFrame:CGRectMake(0, XWtitleofheigth+XWtitlegap+10, Alertwidth, 1)];
        self.lineView.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:self.lineView];
        
        CGFloat contentLabelWidth = Alertwidth - 220;
        self.ramadhinLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(self.lineView.frame) + 20 , 140, 40)];
        self.ramadhinLabel.text = amadhin;
        self.ramadhinLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.ramadhinLabel];
        self.ramadhinTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.ramadhinLabel.frame), CGRectGetMaxY(self.lineView.frame) + 20, contentLabelWidth - 100, 40)];
        
      //  self.ramadhinTextField.text = _ctl.textStr;
        
        self.ramadhinTextField.placeholder = kLocalized(@"Pleaseenteralternatenumberorcellphonenumber");
        self.ramadhinTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.ramadhinTextField.borderStyle = UITextBorderStyleLine;
        
//        GYSinglePointViewController *ctl = [[GYSinglePointViewController alloc] init];
//        ctl.block = ^(NSString *resNo){
//        
//            self.ramadhinTextField.text = resNo;
//        };
        
       // self.ramadhinTextField.secureTextEntry = YES;
        self.ramadhinTextField.delegate = self;
        [self addSubview:self.ramadhinTextField];
        
        if (numberr) {
            
            self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(self.ramadhinLabel.frame) + 20, 140, 40)];
            self.numberLabel.textAlignment = NSTextAlignmentRight;
            self.numberLabel.text = numberr;
          
            [self addSubview:self.numberLabel];
            self.numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numberLabel.frame), CGRectGetMaxY(self.ramadhinLabel.frame) + 20, contentLabelWidth - 100, 40)];
            self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.numberTextField.borderStyle = UITextBorderStyleLine;
            self.numberTextField.secureTextEntry = YES;
            self.numberTextField.placeholder = kLocalized(@"PleaseEnterLoginPassword");
              self.numberTextField.delegate = self;
            [self addSubview:self.numberTextField];
        }
       
        
        CGRect leftbtnFrame;
        CGRect rightbtnFrame;
        
        leftbtnFrame = CGRectMake(100, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth, 100, XWbuttonHeigth);
        rightbtnFrame = CGRectMake(300, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth, 100, XWbuttonHeigth);
        self.leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.leftbtn.frame = leftbtnFrame;
        self.rightbtn.frame = rightbtnFrame;
        
        [self.rightbtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.leftbtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.rightbtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftbtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftbtn.titleLabel.font = self.rightbtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.leftbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftbtn addTarget:self action:@selector(leftbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightbtn addTarget:self action:@selector(rightbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftbtn.layer.masksToBounds = self.rightbtn.layer.masksToBounds = YES;
        self.leftbtn.layer.cornerRadius = self.rightbtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftbtn];
        [self addSubview:self.rightbtn];
        self.alertTitleLabel.text = title;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}
- (void)leftbtnclicked:(UIButton *)sender
{
    sender.enabled =NO;
    [self removeFromSuperview];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightbtnclicked:(UIButton *)sender
{
    [self removeFromSuperview];
    if (self.rightBlock) {
        //传出开台台号， 开台人数
        sender.enabled = NO;
        self.rightBlock(self.ramadhinTextField.text,self.numberTextField.text);
        sender.enabled = YES;
    }
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
    if (textField == self.ramadhinTextField) {
        if(len > 11)
        {
            
            [textField resignFirstResponder];
            
            return NO;
        }
        
        if (len < 11) {
            
        }
       
        return YES;
    }
    if (textField == self.numberTextField) {
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


@end
