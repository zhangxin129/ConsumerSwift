//
//  GYPopView.m
//  HSCompanyPad
//
//  Created by User on 16/8/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYPopView.h"

@implementation GYPopView

- (instancetype)initWithChlidView:(UIView *)chlidView
{
    self = [super init];
    if (self) {
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
    _chlidView.layer.cornerRadius  =  1.0f;
    
}

-(void)show{

    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];

    @weakify(self);
    
    [_chlidView mas_makeConstraints:^(MASConstraintMaker *make) {
      @strongify(self)
        make.center.equalTo(self);
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self disMiss];
}

- (void)disMiss
{
    [self removeFromSuperview];
}

@end
