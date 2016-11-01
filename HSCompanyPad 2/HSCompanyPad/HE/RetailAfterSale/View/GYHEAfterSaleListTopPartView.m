//
//  GYHEAfterSaleListTopPartView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHEAfterSaleListTopPartView.h"
#define kTopHeight kDeviceProportion(12)
#define kButtonWidth kDeviceProportion(150)

@interface GYHEAfterSaleListTopPartView()
@property (nonatomic,strong) UIButton * selectBtn;
@end

@implementation GYHEAfterSaleListTopPartView
- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    NSArray * arr = @[@"未处理售后单",@"已处理售后单",@"全部售后单"];
    UIView * backview = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, kButtonWidth * arr.count, self.frame.size.height - kTopHeight)];
    [self addSubview:backview];
    backview.centerX = self.centerX;
    
    for (int i = 0;i < arr.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(backview.frame.size.width/(arr.count) * i, 0,backview.frame.size.width/(arr.count) , CGRectGetHeight(backview.frame));
        
        
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:kGray555555 forState:UIControlStateNormal];
        button.tag = i + 1;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.backgroundColor = kBlue0D6AEA;
            [button setTitleColor:kWhiteFFFFFF forState:UIControlStateNormal];
            self.selectBtn = button;
        }
        button.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
        [backview addSubview:button];
        UIView* butTailView = [[UIView alloc] initWithFrame:CGRectMake(button.frame.size.width, 0, kDeviceProportion(2), button.frame.size.height)];
        butTailView.backgroundColor = kGrayDBDBEA;
        [button addSubview:butTailView];
    }
}

- (void)click:(UIButton *)button
{
    if (!self.selectBtn) {
        [button setTitleColor:kGray555555 forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        
    }else{
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
