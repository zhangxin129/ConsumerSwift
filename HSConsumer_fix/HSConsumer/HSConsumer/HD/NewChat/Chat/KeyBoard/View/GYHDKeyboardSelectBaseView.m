//
//  GYHDKeyboardSelectBaseView.m
//  HSConsumer
//
//  Created by shiang on 16/3/3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDKeyboardSelectBaseView.h"
#import "Masonry.h"

@implementation GYHDKeyboardSelectBaseView

- (void)show
{
    UIWindow* window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)disMiss
{
    [self removeFromSuperview];
}

@end
