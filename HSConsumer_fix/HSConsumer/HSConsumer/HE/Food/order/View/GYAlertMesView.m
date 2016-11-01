//
//  GYAlertMesView.m
//  HSConsumer
//
//  Created by kuser on 16/4/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAlertMesView.h"
#import <QuartzCore/QuartzCore.h>

#define kAlertWidth 660.0f
#define kAlertHeight 410.0f
#define kScaleX kScreenWidth / 750.0
#define kScaleY kScreenHeight / 1334.0
#define kTitleYOffset 15.0f
#define kTitleHeight 30.0f
#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f
#define kSingleButtonWidth 580.0f
#define kCoupleButtonWidth 280.0f
#define kButtonHeight 100.0f
#define kButtonBottomOffset 30.0f

@interface GYAlertMesView ()

@property (nonatomic, assign) BOOL isleftLeave;
@property (nonatomic, strong) UILabel* alertTitleLabel;
@property (nonatomic, strong) UILabel* alertContentLabel;
@property (nonatomic, strong) UIButton* leftBtn;
@property (nonatomic, strong) UIButton* rightBtn;
@property (nonatomic, strong) UIView* backImageView;

@end

@implementation GYAlertMesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithTitle:(NSString*)title
                  contentText:(NSString*)content
              leftButtonTitle:(NSString*)leftTitle
             rightButtonTitle:(NSString*)rigthTitle
{
    if (self = [super init]) {

        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1];

        CGFloat contentLabelWidth = (kAlertWidth - 80) * kScaleX;
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 * kScaleX, 100 * kScaleY, contentLabelWidth, 36)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.alertContentLabel.textColor = [UIColor colorWithRed:85.0 / 255.0 green:85.0 / 255.0 blue:85.0 / 255.0 alpha:1];
        self.alertContentLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:self.alertContentLabel];

        UIView* lineBlack = [[UIView alloc] initWithFrame:CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5 * kScaleX, 250 * kScaleY, (kAlertWidth - 80) * kScaleX, 1)];
        lineBlack.backgroundColor = [UIColor colorWithRed:190.0 / 255.0 green:190.0 / 255.0 blue:190.0 / 255.0 alpha:1];
        [self addSubview:lineBlack];

        CGRect leftBtnFrame;
        CGRect rightBtnFrame;

        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5 * kScaleX, (kAlertHeight - kButtonBottomOffset - kButtonHeight) * kScaleY, kSingleButtonWidth * kScaleX, kButtonHeight * kScaleY);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
        }
        else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5 * kScaleX, (kAlertHeight - kButtonBottomOffset - kButtonHeight) * kScaleY, kCoupleButtonWidth * kScaleX, kButtonHeight * kScaleY);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset * kScaleX, (kAlertHeight - kButtonBottomOffset - kButtonHeight) * kScaleY, kCoupleButtonWidth * kScaleX, kButtonHeight * kScaleY);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }

        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:250.0 / 255.0 green:60.0 / 255.0 blue:40.0 / 255.0 alpha:1]] forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:252.0 / 255.0 green:252.0 / 255.0 blue:252.0 / 255.0 alpha:1]] forState:UIControlStateNormal];

        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];

        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;

        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)leftBtnClicked:(id)sender
{
    _isleftLeave = YES;

    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dismissAlert];
}

- (void)rightBtnClicked:(id)sender
{
    _isleftLeave = NO;

    if (self.rightBlock) {
        self.rightBlock();
    }
    [self dismissAlert];
}

- (void)show
{
    UIViewController* topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, -kAlertHeight - 30, kAlertWidth * kScaleX, kAlertHeight * kScaleY);
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController*)appRootViewController
{
    UIViewController* appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController* topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    [super removeFromSuperview];
}

- (void)willMoveToSuperview:(UIView*)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController* topVC = [self appRootViewController];

    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth * kScaleX) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight * kScaleX) * 0.5, kAlertWidth * kScaleX, kAlertHeight * kScaleY);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished){
    }];

    [super willMoveToSuperview:newSuperview];
}

@end

@implementation UIImage (colorful)

+ (UIImage*)imageWithColor:(UIColor*)color
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

@end