//
//  GYHSMenberProgressView.m
//
//  Created by apple on 16/8/8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMemberProgressView.h"
#define kLeftWidth kDeviceProportion(16)
#define kTopHeight kDeviceProportion(40)
#define kMidWidth kDeviceProportion(13)
#define kButtonWidth kDeviceProportion(200)
#define kButtonHeight kDeviceProportion(30)
#define kLineHeight kDeviceProportion(25)
#define kLineWidth kDeviceProportion(3)

@interface GYHSMemberProgressView ()

@property (nonatomic, strong) NSArray* array;
@property (nonatomic, strong) NSMutableArray* dataArray;

@end
@implementation GYHSMemberProgressView

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray*)array
{
    if (self = [super initWithFrame:frame]) {
        self.array = array;
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scroll];
    for (int i = 0; i < self.array.count; i++) {
    
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kLeftWidth, kTopHeight + (kLineHeight + kButtonHeight) * i, kButtonWidth, kButtonHeight);
        [button setTitle:self.array[i] forState:UIControlStateNormal];
        [button setTitleColor:kGray666666 forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"gyhs_progress_gray"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, button.width - kLeftWidth);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, kMidWidth, 0, 0);
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(kLeftWidth + (button.imageView.width - kLineWidth) / 2, CGRectGetMaxY(button.frame), kLineWidth, kLineHeight)];
        line.backgroundColor = kDefaultVCBackgroundColor;
        [scroll addSubview:button];
        [self.dataArray addObject:button];
        [scroll addSubview:line];
        if (i == self.array.count - 1) {
            [line removeFromSuperview];
            scroll.contentSize = CGSizeMake(0, CGRectGetMaxY(button.frame));
        }
    }
}

#pragma mark - setter
- (void)setIndex:(NSInteger)index
{
    _index = index;
    for (int i = 0; i < self.dataArray.count; i++) {
        UIButton* button = self.dataArray[i];
        if (i <= self.index - 1) {
            [button setTitleColor:kGray333333 forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"gyhs_progress_green"] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:kGray666666 forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"gyhs_progress_gray"] forState:UIControlStateNormal];
        }
    }
}

@end
