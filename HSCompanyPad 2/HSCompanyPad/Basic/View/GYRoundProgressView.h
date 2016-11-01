//
//  GYRoundProgressView.h
//  HSCompanyPad
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYRoundProgressView : UIView
@property (nonatomic, assign) CGFloat lineWidth UI_APPEARANCE_SELECTOR;//进度圈宽度
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;//背景圈宽度
@property (nonatomic, strong) UIColor *tintColor;//进度圈颜色
@property (nonatomic, assign) CGFloat progress;//进度值（0~1）
@property (nonatomic, copy) void (^didSelectBlock)(GYRoundProgressView *progressView);

- (void)refreshProgress:(CGFloat)progress;

@end
