//
//  GYAlertWithFieldView.m
//  GYRestaurant
//
//  Created by apple on 15/10/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAlertWithFieldView.h"

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

@interface GYAlertWithFieldView ()
{
    BOOL _leftLeave;
}

@property (nonatomic, copy) NSString *deposit;//用来传递订金

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *ramadhinLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *leftbtn;
@property (nonatomic, strong) UIButton *rightbtn;
@property (nonatomic, strong) UIView *backimageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *tipsLable;
@property (nonatomic, strong) UILabel *cancelLable;
@property (nonatomic, strong) UILabel *receivedDepositLable;
@property (nonatomic, strong) UILabel *depositLable;
@property (nonatomic, strong) UIButton *returnbtn;
@property (nonatomic, strong) UIButton *noReturnbtn;
@property (nonatomic, strong) UILabel *returnLable;
@property (nonatomic, strong) UILabel *noReturnLable;
@property (nonatomic, strong) UILabel *returnDepositLable;
@property (nonatomic, strong) UILabel *reDepositLable;
@property (nonatomic, copy)   NSString *returnStatusStr;
@end

@implementation GYAlertWithFieldView

+ (CGFloat)alertWidth
{
    return Alertwidth;
}

+ (CGFloat)alertHeight
{
    return Alertheigth;
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
        self.ramadhinLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(self.lineView.frame) + 20 , 100, 40)];
        self.ramadhinLabel.text = [amadhin stringByAppendingString:@"："];
        self.ramadhinLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.ramadhinLabel];
        self.ramadhinTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.ramadhinLabel.frame), CGRectGetMaxY(self.lineView.frame) + 20, contentLabelWidth - 100, 40)];
        self.ramadhinTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.ramadhinTextField.borderStyle = UITextBorderStyleLine;
        [self addSubview:self.ramadhinTextField];
        
        if (numberr) {
         
            self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(self.ramadhinLabel.frame) + 20, 100, 40)];
            self.numberLabel.text = [numberr stringByAppendingString:@"："];
            self.numberLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:self.numberLabel];
            self.numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numberLabel.frame), CGRectGetMaxY(self.ramadhinLabel.frame) + 20, contentLabelWidth - 100, 40)];
            self.numberTextField.keyboardType = UIKeyboardTypeDefault;
            self.numberTextField.borderStyle = UITextBorderStyleLine;
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
- (void)leftbtnclicked:(id)sender
{
    [self removeFromSuperview];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightbtnclicked:(id)sender
{
    [self removeFromSuperview];
    if (self.rightBlock) {
        //传出开台台号， 开台人数
        self.rightBlock(self.ramadhinTextField.text,self.numberTextField.text);
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


- (id)initCancelView:(NSString*)deposit
{
    if (self = [super init]) {
        self.deposit = deposit;
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, XWtitlegap-25, Alertwidth, XWtitleofheigth)];
         self.alertTitleLabel.text = kLocalized(@"Cancellationconfirmation");
        
        self.alertTitleLabel.font = [UIFont systemFontOfSize:24];
        self.alertTitleLabel.textColor=[UIColor blackColor];
        self.alertTitleLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.alertTitleLabel];
        
        self.lineView=[[UIView alloc] initWithFrame:CGRectMake(0, XWtitleofheigth+XWtitlegap-15, Alertwidth, 1)];
        self.lineView.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:self.lineView];
        
//        self.tipsLable=[[UILabel alloc]initWithFrame:CGRectMake(50, XWtitleofheigth+XWtitlegap-10, Alertwidth-65, 20)];
//        self.tipsLable.text = kLocalized(@"Tipsplatformhasreceivedthedepositchargedofcommercialservicecharge");
        self.tipsLable.textColor = [UIColor lightGrayColor];
        self.tipsLable.font = [UIFont systemFontOfSize:15];
        self.tipsLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.tipsLable];
        
        self.cancelLable=[[UILabel alloc] initWithFrame:CGRectMake(50, XWtitleofheigth+XWtitlegap+20, 90, 25)];
        self.cancelLable.text = kLocalizedAddParams(kLocalized(@"Groundsforcancellation"), @":");
        self.cancelLable.textColor = [UIColor lightGrayColor];
        self.cancelLable.font = [UIFont systemFontOfSize:18];
        self.cancelLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.cancelLable];
        
        self.cancelTF=[[UITextField alloc] initWithFrame:CGRectMake(140, XWtitleofheigth+XWtitlegap+20, Alertwidth-150, 30)];
        self.cancelTF.keyboardType = UIKeyboardTypeNamePhonePad;
        self.cancelTF.borderStyle = UITextBorderStyleLine;
        [self addSubview:self.cancelTF];
        
        self.receivedDepositLable=[[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.cancelTF.frame)+10, 90, 25)];
        self.receivedDepositLable.text = kLocalizedAddParams(kLocalized(@"receivedthedeposit"), @":");
        self.receivedDepositLable.textColor = [UIColor lightGrayColor];
        self.receivedDepositLable.font = [UIFont systemFontOfSize:18];
        self.receivedDepositLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.receivedDepositLable];
        
        UIImageView *coin1=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.receivedDepositLable.frame), CGRectGetMaxY(self.cancelTF.frame)+13 , 20, 20)];
        [coin1 setImage:[UIImage imageNamed:@"coin"]];
        [self addSubview:coin1];
        
        self.depositLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coin1.frame), CGRectGetMaxY(self.cancelTF.frame)+10, Alertwidth-170, 25)];
        self.depositLable.text = deposit;
        self.depositLable.textColor=kRedFontColor;
        self.depositLable.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.depositLable];
        
        self.returnbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.returnbtn.frame=CGRectMake(CGRectGetMaxX(self.receivedDepositLable.frame), CGRectGetMaxY(self.receivedDepositLable.frame)+13, 20, 20);
        [self.returnbtn setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
        [self.returnbtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [self.returnbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.returnbtn.tag = 100;
        [self addSubview:self.returnbtn];
        
        self.returnLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.returnbtn.frame)+5, CGRectGetMaxY(self.receivedDepositLable.frame)+10, 80, 25)];
        self.returnLable.text=kLocalized(@"Fullrefund");
        self.returnLable.textColor=[UIColor lightGrayColor];
        [self addSubview:self.returnLable];
        
//        self.noReturnbtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        self.noReturnbtn.frame=CGRectMake(CGRectGetMaxX(self.returnLable.frame)+20, CGRectGetMaxY(self.receivedDepositLable.frame)+13, 20, 20);
//        [self.noReturnbtn setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
//        [self.noReturnbtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
//        [self.noReturnbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//        self.noReturnbtn.tag = 101;
//        [self addSubview:self.noReturnbtn];
//        
//        self.noReturnLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.noReturnbtn.frame)+3, CGRectGetMaxY(self.receivedDepositLable.frame)+10, 60, 25)];
//        self.noReturnLable.text=kLocalized(@"nonrefundable");
//        self.noReturnLable.textColor=[UIColor lightGrayColor];
//        [self addSubview:self.noReturnLable];
        
        self.returnDepositLable=[[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.returnLable.frame)+10, 90, 25)];
        self.returnDepositLable.text = kLocalizedAddParams(kLocalized(@"Refundofdeposit"), @":");
        self.returnDepositLable.textColor = [UIColor lightGrayColor];
        self.returnDepositLable.font = [UIFont systemFontOfSize:18];
        self.returnDepositLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.returnDepositLable];
        
        UIImageView *coin2=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.returnDepositLable.frame), CGRectGetMaxY(self.returnLable.frame)+13 , 20, 20)];
        [coin2 setImage:[UIImage imageNamed:@"coin"]];
        [self addSubview:coin2];
        
        self.reDepositLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coin2.frame), CGRectGetMaxY(self.returnLable.frame)+10, Alertwidth-170, 25)];
        self.reDepositLable.text=deposit;
        self.reDepositLable.textColor=kRedFontColor;
        self.reDepositLable.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.reDepositLable];
        
        CGRect leftbtnFrame;
        CGRect rightbtnFrame;
        
        leftbtnFrame = CGRectMake(100, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth+10, 100, XWbuttonHeigth);
        rightbtnFrame = CGRectMake(300, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth+10, 100, XWbuttonHeigth);
        self.leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftbtn.frame = leftbtnFrame;
        self.rightbtn.frame = rightbtnFrame;
        
        [self.rightbtn setBackgroundColor:[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0]];
        [self.leftbtn setBackgroundColor:[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0]];
        [self.rightbtn setTitle:kLocalized(@"Determine") forState:UIControlStateNormal];
        [self.leftbtn setTitle:kLocalized(@"Cancel") forState:UIControlStateNormal];
        self.leftbtn.titleLabel.font = self.rightbtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.leftbtn setTitleColor:[UIColor colorWithRed:97/255.0 green:96/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.rightbtn setTitleColor:[UIColor colorWithRed:97/255.0 green:96/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.leftbtn addTarget:self action:@selector(leftbtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightbtn addTarget:self action:@selector(rightbtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.leftbtn.layer.masksToBounds = self.rightbtn.layer.masksToBounds = YES;
        self.leftbtn.layer.cornerRadius = self.rightbtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftbtn];
        [self addSubview:self.rightbtn];

        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [self btnAction:self.returnbtn];
    }
    return self;
}

- (void)leftbtnAction:(UIButton*)btn{
    [self removeFromSuperview];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightbtnAction:(UIButton*)btn{
    [self removeFromSuperview];
    if (self.returnBlock) {
        self.returnBlock(self.returnStatusStr, self.cancelTF.text,self.deposit);
    }
}

-(void)btnAction:(UIButton *)btn{
    self.returnbtn.selected = NO;
    self.noReturnbtn.selected = NO;
    if (btn.tag == 100) {
        self.returnStatusStr = @"1";
        self.reDepositLable.text = self.deposit;
        self.returnbtn.selected = YES;
    }
    if (btn.tag == 101) {
        self.returnStatusStr = @"2";
        self.reDepositLable.text=@"0.00";
        self.noReturnbtn.selected = YES;
    }
}

-(NSString *)deposit{
    if ([_returnStatusStr isEqualToString:@"1"]) {
        return _deposit;
    }else{
        return @"0.00";
    }
}


@end
