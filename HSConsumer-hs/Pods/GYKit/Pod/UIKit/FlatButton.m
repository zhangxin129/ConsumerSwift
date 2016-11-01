//
//  FlatButton.m
//  Popping
//
//  Created by André Schneider on 12.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "FlatButton.h"
#import <POP/POP.h>

@interface FlatButton ()
- (void)setup;
- (void)scaleToSmall;
- (void)scaleAnimation;
- (void)scaleToDefault;
@end

@implementation FlatButton

+ (instancetype)button
{
    return [self buttonWithType:UIButtonTypeCustom];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Instance methods

- (UIEdgeInsets)titleEdgeInsets
{
    return UIEdgeInsetsMake(4.f, 28.f, 4.f, 28.f);
}

- (CGSize)intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    
    return CGSizeMake(s.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
        s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
}

#pragma mark - Private instance methods

- (void)setup
{
    [self setExclusiveTouch:YES];
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 4.f;
    [self setTitleColor:[UIColor whiteColor]
               forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self addTarget:self action:@selector(scaleToSmall)
        forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation)
        forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault)
        forControlEvents:UIControlEventTouchDragExit];
}

- (void)scaleToSmall
{
    POPBasicAnimation* scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation
{
    POPSpringAnimation* scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault
{
    POPBasicAnimation* scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}

//// 内部图片的frame
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat imageW = self.frame.size.width * 0.4 - 10 * 0.4;
//    CGFloat imageH = self.frame.size.height * 0.4;
//    return CGRectMake(self.frame.size.width - imageW - 12, self.frame.size.height / 2 - imageH / 2, imageW, imageH);
//}

@end
