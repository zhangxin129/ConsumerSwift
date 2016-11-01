//
//  GYHSPopView.m
//  HSConsumer
//
//  Created by kuser on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPopView.h"
#import "Masonry.h"
#import "YYKit.h"

@implementation GYHSPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //蒙版
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
    }
    return self;
}

- (void)showView:(UIViewController *)vc
{
    //按钮
    CGFloat spaceView = 100;
    if (kIS_IPHONE_4_OR_LESS) {
        spaceView = 50;
    }
    
    //按钮
    self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 16, kScreenHeight - spaceView, 32, 32)];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_account_delete_view"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(dismissViewPop) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.hidden = self.hiddenCloseBtn;
    
    //弹出视图
    self.popView = [[UIView alloc]init];
    self.popView.frame = CGRectMake(10, spaceView, kScreenWidth - 20, kScreenHeight - spaceView * 2 - 20);
    self.popView.backgroundColor = [UIColor whiteColor];
    self.popView.clipsToBounds = YES;
    self.popView.layer.cornerRadius = 10;
    //蒙版加入按钮，弹出视图
    [self addSubview:self.popView];
    [self addSubview:self.closeBtn];
    //蒙版加入window上
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
     [[UIApplication sharedApplication].delegate.window.rootViewController addChildViewController:vc];
    [self.popView addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.popView);
    }];
}

- (void)showView:(UIViewController *)vc withViewFrame:(CGRect)viewFrame
{
    //弹出视图
    self.popView = [[UIView alloc]init];
    CGFloat viewHeight = viewFrame.size.height;
    CGFloat y = (kScreenHeight - viewHeight - 65) * 0.5;
    viewFrame.origin.y = y;
    self.popView.frame = viewFrame;
    self.popView.backgroundColor = [UIColor whiteColor];
    self.popView.clipsToBounds = YES;
    self.popView.layer.cornerRadius = 10;
    //蒙版加入按钮，弹出视图
    [self addSubview:self.popView];
    //按钮
    self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 16, kScreenHeight - 100.0, 32, 32)];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_account_delete_view"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(dismissViewPop) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.frame = CGRectMake(kScreenWidth/2 -20, self.popView.bottom +20, 40, 40);
    [self addSubview:self.closeBtn];
    
    if (self.hiddenCloseBtn) {
        self.closeBtn.hidden = YES;
        
        CGFloat y = (kScreenHeight - viewHeight) * 0.5;
        viewFrame.origin.y = y;
        self.popView.frame = viewFrame;
    }
    
    //蒙版加入window上
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    [[UIApplication sharedApplication].delegate.window.rootViewController addChildViewController:vc];
    [self.popView addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.popView);
    }];
}

// 按背景关闭
- (void)showViews:(UIViewController *)vc withViewFrame:(CGRect)viewFrames
{
    //二维码弹出视图
    self.popView = [[UIView alloc]init];
    CGFloat viewHeight = viewFrames.size.height;
    CGFloat y = (kScreenHeight - viewHeight) * 0.5;
    viewFrames.origin.y = y;
    self.popView.frame = viewFrames;
    self.popView.backgroundColor = [UIColor whiteColor];
    self.popView.clipsToBounds = YES;
    self.popView.layer.cornerRadius = 10;
    //蒙版加入按钮，弹出视图
    [self addSubview:self.popView];
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewPop)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1;
    //给self.view添加一个手势监测；
    [self addGestureRecognizer:singleRecognizer];
    //蒙版加入window上
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    [[UIApplication sharedApplication].delegate.window.rootViewController addChildViewController:vc];
    [self.popView addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.popView);
    }];
}

-(void)showView
{
    //按钮
    CGFloat spaceView = 100;
    if (kIS_IPHONE_4_OR_LESS) {
        spaceView = 50;
    }
    
    self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 16, kScreenHeight - spaceView, 32, 32)];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_account_delete_view"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(dismissViewPop) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.hidden = self.hiddenCloseBtn;
    
    //弹出视图
    self.popView = [[UIView alloc]init];
    self.popView.frame = CGRectMake(10, spaceView, kScreenWidth - 20, kScreenHeight - spaceView * 2 - 20);
    self.popView.backgroundColor = [UIColor whiteColor];
    self.popView.clipsToBounds = YES;
    self.popView.layer.cornerRadius = 10;
    //蒙版加入按钮，弹出视图
    [self addSubview:self.popView];
    [self addSubview:self.closeBtn];
    //蒙版加入window上
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

-(void)dismissViewPop
{
    [self removeFromSuperview];
    [self disVCClick];
}

- (void)disVCClick { 
    if ([self.delegate respondsToSelector:@selector(disMissBtnClickDelegate)]) {
        [self.delegate disMissBtnClickDelegate];
    }
}


@end
