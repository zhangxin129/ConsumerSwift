//
//  GYHDPopView.m
//  HSConsumer
//
//  Created by shiang on 16/1/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPopView.h"
#import "GYHDMessageCenter.h"

@interface GYHDPopView ()
@property (nonatomic, strong) UIView* chlidView;
@end

@implementation GYHDPopView

- (instancetype)initWithChlidView:(UIView*)chlidView
{
    self = [super init];
    if (self) {
        if (kScreenHeight < 586) {
            _showType = GYHDPopViewShowTop;
        }
        else {
            _showType = GYHDPopViewShowCenter;
        }

        _chlidView = chlidView;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:_chlidView];
    _chlidView.layer.masksToBounds = YES;
    _chlidView.layer.cornerRadius = 10.0f;
    //    WS(weakSelf);
    //    [_chlidView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.equalTo(weakSelf);
    //    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setShowType:(GYHDPopViewShowType)showType
{
    _showType = showType;
}

- (void)show
{

    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in window.subviews) {
        
        if ([view isKindOfClass:[self class]]) {
            
            return;
        }
    }
    [window addSubview:self];
   
    WS(weakSelf);
    switch (_showType) {
    case GYHDPopViewShowTop: {
        [_chlidView mas_updateConstraints:^(MASConstraintMaker* make) {
                make.top.equalTo(weakSelf).offset(20);
                make.centerX.equalTo(weakSelf);
        }];

        break;
    }
    case GYHDPopViewShowCenter: {

        [_chlidView mas_updateConstraints:^(MASConstraintMaker* make) {
                make.centerX.equalTo(weakSelf);
                make.centerY.equalTo(weakSelf).offset(-64);
        }];
        break;
    }
    case GYHDPopViewShowBottom: {
        [_chlidView mas_updateConstraints:^(MASConstraintMaker* make) {
                make.bottom.equalTo(weakSelf);
                make.centerX.equalTo(weakSelf);
        }];
        break;
    }
    default:
        break;
    }
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [self disMiss];
}

- (void)disMiss
{
    [self removeFromSuperview];
}

@end
