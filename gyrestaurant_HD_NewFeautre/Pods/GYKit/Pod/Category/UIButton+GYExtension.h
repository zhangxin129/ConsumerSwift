//
//  UIButton+GYExtension.h
//  Pods
//
//  Created by sqm on 16/6/16.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (GYExtension)
#pragma mark - 定时器
-(void)startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle;


#pragma mark - 扩大点击
//扩大button的点击范围
-(void)setEnlargEdgeWithTop : (CGFloat )top right :(CGFloat)right bottom :(CGFloat )bottom left :(CGFloat)left;

//add by liangzm 添加边框
- (void)setBorderWithWidth:(CGFloat)width andRadius:(CGFloat)radius andColor:(UIColor *)color;


#pragma mark - 超时
- (void)controlTimeOut;
- (void)controlTimeOutWithSecond:(NSInteger)second;
@end
