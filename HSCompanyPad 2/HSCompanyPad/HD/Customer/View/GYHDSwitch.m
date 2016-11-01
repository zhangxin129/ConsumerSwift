//
//  GYHDSwitch.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/17.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDSwitch.h"

@implementation GYHDSwitch

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    
    [self setBackgroundImage:[UIImage imageNamed:@"gyhd_switch_advisory_end_btn_normal"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"gyhd_switch_advisory_end_btn_select"] forState:UIControlStateSelected];
    [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.oneTitle = [[UILabel alloc] init];
    self.oneTitle.font = [UIFont systemFontOfSize:16.0f];
    self.oneTitle.textColor = [UIColor whiteColor];
    self.oneTitle.text = kLocalized(@"GYHD_SessionIng");
    [self addSubview:self.oneTitle];
    
    self.twoTitle = [[UILabel alloc] init];
    self.twoTitle.font = [UIFont systemFontOfSize:16.0f];
    self.twoTitle.textColor = [UIColor colorWithHex:0xff9c3b];
    self.twoTitle.text = kLocalized(@"GYHD_Session_Endless");
    [self addSubview:self.twoTitle];
    @weakify(self);
    [self.oneTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).multipliedBy(0.5);
    }];
    
    [self.twoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).multipliedBy(1.5);
    }];
    
}
- (void)btnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.twoTitle.textColor = [UIColor whiteColor];
        self.oneTitle.textColor = [UIColor colorWithHex:0xff9c3b];
    }else {
        self.oneTitle.textColor = [UIColor whiteColor];
        self.twoTitle.textColor = [UIColor colorWithHex:0xff9c3b];
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(GYHDSwitch:select:)]) {
            [self.delegate GYHDSwitch:self select:btn.selected];
        }
    }
}

@end
