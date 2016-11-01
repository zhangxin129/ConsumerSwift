//
//  GYHSPointCheckView.m
//
//  Created by apple on 16/7/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointCheckView.h"

#define kTopHeight kDeviceProportion(12)
#define kButtonWidth kDeviceProportion(120)
@interface GYHSPointCheckView ()
@property (nonatomic, strong) UIButton* selectBtn;
@end
@implementation GYHSPointCheckView
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
    NSArray* arr = @[ kLocalized(@"GYHS_Point_Consume"), kLocalized(@"GYHS_Point_Consume_Cancel"), kLocalized(@"GYHS_Point_Consume_Return")];
    UIView* backview = [[UIView alloc] initWithFrame:CGRectMake(0, kTopHeight, kButtonWidth * arr.count, self.frame.size.height - kTopHeight)];
    [self addSubview:backview];
    backview.centerX = self.centerX;
    for (int i = 0; i < arr.count; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(backview.frame.size.width / (arr.count) * i, 0, backview.frame.size.width / (arr.count), CGRectGetHeight(backview.frame));
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:kGray555555 forState:UIControlStateNormal];
        button.tag = i + 1;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.backgroundColor = kBlue0A59C2;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.selectBtn = button;
        }
        button.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
        [backview addSubview:button];
    }
}

#pragma mark - clcik
- (void)click:(UIButton*)button
{
    if (!self.selectBtn) {
        [button setTitleColor:kGray555555 forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        
    } else {
        [self.selectBtn setTitleColor:kGray555555 forState:UIControlStateNormal];
        self.selectBtn.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = kBlue0A59C2;
    }
    self.selectBtn = button;
    if (_delegate && [_delegate respondsToSelector:@selector(click:)]) {
        [_delegate click:button.tag];
    }
}


@end
