//
//  GYHSPointListView.m
//
//  Created by apple on 16/7/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointListView.h"

#define kBtnHeight kDeviceProportion(35)
@interface GYHSPointListView ()

@end
@implementation GYHSPointListView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setArray:(NSArray*)array
{
    for (UIButton* button in self.subviews) {
        [button removeFromSuperview];
    }
    
    _array = array;
    [self setUI:_array];
}

- (void)setUI:(NSArray*)array
{
    CGFloat btnwidth = self.size.width / (array.count + 1);
    CGFloat btnheight = 35;
    for (int i = 0; i < array.count; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnwidth * i, 0, btnwidth, btnheight);
        if (i == array.count - 1) {
            button.width = btnwidth * 2;
        }
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:kGray777777 forState:UIControlStateNormal];
        if ([button.titleLabel.text isEqualToString:kLocalized(@"GYHS_Point_Real_Cash")]) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
            [button setImage:[UIImage imageNamed:@"gyhs_point_min_coin"] forState:UIControlStateNormal];
        }
        if ([button.titleLabel.text isEqualToString:kLocalized(@"GYHS_Point_Point_Cash")]) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
            [button setImage:[UIImage imageNamed:@"gyhs_point_min"] forState:UIControlStateNormal];
        }
        if ([button.titleLabel.text isEqualToString:kLocalized(@"GYHS_Point_Cancel_Cash")]) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
            [button setImage:[UIImage imageNamed:@"gyhs_point_min_consume"] forState:UIControlStateNormal];
        }
        if ([button.titleLabel.text isEqualToString:kLocalized(@"GYHS_Point_Return_Cash")]) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
            [button setImage:[UIImage imageNamed:@"gyhs_point_min_consume"] forState:UIControlStateNormal];
        }
        button.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
        [self addSubview:button];
    }
    
}

@end
