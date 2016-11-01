//
//  UIView+CustomBorder.m
//  HSConsumer
//
//  Created by apple on 14-11-28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "UIView+CustomBorder.h"
#import <objc/runtime.h>

static char const* const clayerTopBorderKey = "kclayerTopBorderKey";
static char const* const clayerBottomBorderKey = "kclayerBottomBorderKey";
static char const* const clayerLeftBorderKey = "kclayerLeftBorderKey";
static char const* const clayerRightBorderKey = "kclayerRightBorderKey";

@implementation UIView (CustomBorder)

- (void)moveX:(CGFloat)x moveY:(CGFloat)y
{
    CGRect newFrame = self.frame;
    newFrame.origin.x += x;
    newFrame.origin.y += y;
    self.frame = newFrame;
}

- (id)clayerTopBorderKey
{
    return objc_getAssociatedObject(self, clayerTopBorderKey);
}

- (void)setCustomLayer:(id)layer withKey:(const void*)key
{
    objc_setAssociatedObject(self, key, layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)customLayerFromKey:(const void*)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)addTopBorder
{
    [self addTopBorderWithBorderWidth:kDefaultViewBorderWidth andBorderColor:kDefaultViewBorderColor];
}

- (void)addTopBorderWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor*)color
{
    id l = [self customLayerFromKey:clayerTopBorderKey];
    if (l)
        return;

    CALayer* topBorder = [CALayer layer];
    topBorder.backgroundColor = [color CGColor];
    topBorder.frame = CGRectMake(0, 0, kScreenWidth, borderWidth);
    [self setCustomLayer:topBorder withKey:clayerTopBorderKey];
    [self.layer addSublayer:topBorder];
}

- (void)addBottomBorder
{
    [self addBottomBorderWithBorderWidth:kDefaultViewBorderWidth andBorderColor:kDefaultViewBorderColor];
}

- (void)addBottomBorderWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor*)color
{
    id l = [self customLayerFromKey:clayerBottomBorderKey];
    if (l)
        return;

    CALayer* bottomBorder = [CALayer layer];
    bottomBorder.backgroundColor = [color CGColor];
    bottomBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame), kScreenWidth, borderWidth);
    [self setCustomLayer:bottomBorder withKey:clayerBottomBorderKey];
    [self.layer addSublayer:bottomBorder];
}

- (void)addLeftBorder
{
    [self addLeftBorderWithBorderWidth:kDefaultViewBorderWidth andBorderColor:kDefaultViewBorderColor];
}

- (void)addLeftBorderWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor*)color
{
    id l = [self customLayerFromKey:clayerLeftBorderKey];
    if (l)
        return;

    CALayer* leftBorder = [CALayer layer];
    leftBorder.backgroundColor = [color CGColor];
    leftBorder.frame = CGRectMake(0, 0, borderWidth, CGRectGetHeight(self.frame));
    [self setCustomLayer:leftBorder withKey:clayerLeftBorderKey];
    [self.layer addSublayer:leftBorder];
}

- (void)addRightBorder
{
    [self addRightBorderWithBorderWidth:kDefaultViewBorderWidth andBorderColor:kDefaultViewBorderColor];
}

- (void)addRightBorderWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor*)color
{
    id l = [self customLayerFromKey:clayerRightBorderKey];
    if (l)
        return;

    CALayer* rightBorder = [CALayer layer];
    rightBorder.backgroundColor = [color CGColor];
    rightBorder.frame = CGRectMake(kScreenWidth, 0, borderWidth, CGRectGetHeight(self.frame));
    [self setCustomLayer:rightBorder withKey:clayerRightBorderKey];
    [self.layer addSublayer:rightBorder];
}

- (void)removeTopBorder
{
    CALayer* l = [self customLayerFromKey:clayerTopBorderKey];
    if (!l)
        return;
    if (l.superlayer) {
        [l removeFromSuperlayer];
        [self setCustomLayer:nil withKey:clayerTopBorderKey];
    }
}

- (void)removeBottomBorder
{
    CALayer* l = [self customLayerFromKey:clayerBottomBorderKey];
    if (!l)
        return;
    if (l.superlayer) {
        [l removeFromSuperlayer];
        [self setCustomLayer:nil withKey:clayerBottomBorderKey];
    }
}

- (void)removeLeftBorder
{
    CALayer* l = [self customLayerFromKey:clayerLeftBorderKey];
    if (!l)
        return;
    if (l.superlayer) {
        [l removeFromSuperlayer];
        [self setCustomLayer:nil withKey:clayerLeftBorderKey];
    }
}

- (void)removeRightBorder
{
    CALayer* l = [self customLayerFromKey:clayerRightBorderKey];
    if (!l)
        return;
    if (l.superlayer) {
        [l removeFromSuperlayer];
        [self setCustomLayer:nil withKey:clayerRightBorderKey];
    }
}

- (void)addAllBorder
{
    [self addTopBorder];
    [self addBottomBorder];
    [self addLeftBorder];
    [self addRightBorder];
}

- (void)addTopBorderAndBottomBorder
{
    [self addTopBorder];
    [self addBottomBorder];
}

- (void)addAllBorderWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor*)color
{
    [self addTopBorderWithBorderWidth:borderWidth andBorderColor:color];
    [self addBottomBorderWithBorderWidth:borderWidth andBorderColor:color];
    [self addLeftBorderWithBorderWidth:borderWidth andBorderColor:color];
    [self addRightBorderWithBorderWidth:borderWidth andBorderColor:color];
}

- (void)removeAllBorder
{
    [self removeTopBorder];
    [self removeBottomBorder];
    [self removeLeftBorder];
    [self removeRightBorder];
}

- (void)setBottomBorderInset:(BOOL)isInset
{
    CALayer* l = [self customLayerFromKey:clayerBottomBorderKey];
    if (!l)
        return;
    if (l.superlayer) {
        if (isInset)
            l.frame = CGRectMake(0, CGRectGetHeight(self.frame) - l.frame.size.height, kScreenWidth, l.frame.size.height);
        else
            l.frame = CGRectMake(0, CGRectGetHeight(self.frame), kScreenWidth, l.frame.size.height);
    }
}

- (void)setRightBorderInset:(BOOL)isInset
{
    CALayer* l = [self customLayerFromKey:clayerRightBorderKey];
    if (!l)
        return;
    if (l.superlayer) {
        if (isInset)
            l.frame = CGRectMake(kScreenWidth - l.frame.size.width, 0, l.frame.size.width, CGRectGetHeight(self.frame));
        else
            l.frame = CGRectMake(kScreenWidth, 0, l.frame.size.width, CGRectGetHeight(self.frame));
    }

}

@end
