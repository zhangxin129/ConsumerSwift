				//
//  GYAlertView.m
//  GYRestaurant
//
//  Created by apple on 15/10/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAlertView.h"

#define Alertwidth 500.0f
#define Alertheigth 300.0f
#define XWtitlegap 50.0f
#define XWtitleofheigth 25.0f
#define XWSinglebuttonWidth 160.0f
//        单个按钮时的宽度
#define XWdoublebuttonWidth 100.0f
//        双个按钮的宽度
#define XWbuttonHeigth 50.0f
//        按钮的高度
#define XWbuttonbttomgap 20.0f
//        设置按钮距离底部的边距
@interface GYAlertView ()
{
    BOOL _leftLeave;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;

@property (nonatomic, strong) UIView *backimageView;


@end

@implementation GYAlertView
+ (CGFloat)alertWidth
{
    return Alertwidth;
}

+ (CGFloat)alertHeight
{
    return Alertheigth;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, XWtitlegap, Alertwidth, XWtitleofheigth)];
        self.alertTitleLabel.font = [UIFont systemFontOfSize:18];
        self.alertTitleLabel.textColor=[UIColor lightGrayColor];
        self.alertTitleLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.alertTitleLabel];
        
        self.lineView=[[UIView alloc] initWithFrame:CGRectMake(0, XWtitleofheigth+XWtitlegap+10, Alertwidth, 1)];
        self.lineView.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:self.lineView];
        
        CGFloat contentLabelWidth = Alertwidth - 16-20;
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((Alertwidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame)-15, contentLabelWidth, 60)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textColor = [UIColor blackColor];
        self.alertContentLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.alertContentLabel];
        //        设置对齐方式
      //  self.alertContentLabel.textAlignment = self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth - 10 , Alertwidth, 1)];
        self.bottomLineView.backgroundColor=[UIColor lightGrayColor];
        self.bottomLineView.hidden = YES;
        [self addSubview:self.bottomLineView];
        
        CGRect leftbtnFrame;
        CGRect rightbtnFrame;
        
        if (!leftTitle) {
            rightbtnFrame = CGRectMake(20 , Alertheigth - XWbuttonbttomgap - XWbuttonHeigth, Alertwidth - 40 , XWbuttonHeigth);
            self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightbtn.frame = rightbtnFrame;
            
        }else {
            leftbtnFrame = CGRectMake(100, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth, 100, XWbuttonHeigth);
            
            rightbtnFrame = CGRectMake(300, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth, 100, XWbuttonHeigth);
            self.leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftbtn.frame = leftbtnFrame;
            self.rightbtn.frame = rightbtnFrame;
        }
        
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
        self.alertContentLabel.text = content;
        
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}
- (void)leftbtnclicked:(UIButton*)sender
{
    sender.enabled = NO;
    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dismissAlert];
}

- (void)rightbtnclicked:(UIButton*)sender
{
    if (self.rightBlock) {
        sender.enabled = NO;
        self.rightBlock();
        sender.enabled = YES;
    }
    [self dismissAlert];
}
- (void)show
{   //获取第一响应视图视图
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - Alertwidth) * 0.5-30, (CGRectGetHeight(topVC.view.bounds) - Alertheigth) * 0.5-20, Alertwidth, Alertheigth);
    self.alpha=0;
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
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
        [super  removeFromSuperview];
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

@end
