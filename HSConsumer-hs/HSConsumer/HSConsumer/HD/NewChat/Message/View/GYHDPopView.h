//
//  GYHDPopView.h
//  HSConsumer
//
//  Created by shiang on 16/1/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYHDPopViewShowType) {
    GYHDPopViewShowTop = 0, // 顶部
    GYHDPopViewShowCenter, // 中间
    GYHDPopViewShowBottom, //中间
};

@interface GYHDPopView : UIView
@property (nonatomic, assign) GYHDPopViewShowType showType;
- (void)show;
- (void)showToView:(UIView *)view;
- (void)disMiss;
- (instancetype)initWithChlidView:(UIView *)chlidView;
@end
