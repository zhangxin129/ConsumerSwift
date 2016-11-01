//
//  GYHSCustomedDraw.m
//  HSCompanyPad
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCustomedDraw.h"

@implementation GYHSCustomedDraw

#pragma mark - 绘制按钮动画
+ (void)setAnimationWithLayer:(UIButton*)btn
{

    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray* values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [btn.layer addAnimation:animation forKey:nil];
}

#pragma mark - 绘制按钮旋转动画
+ (void)setRoateWithhLayer:(UIButton*)btn
{

    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 0.3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    [btn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
