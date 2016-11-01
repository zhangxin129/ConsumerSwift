//
//  GYQRCodeReaderView.h
//  HSCompanyPad
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYHSCodeReaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface GYHSCodeReaderView ()
@property (nonatomic, strong) CAShapeLayer* overlay;
@property (nonatomic, strong) UIImageView* img1, *img2, *img3, *img4;
@end

@implementation GYHSCodeReaderView

- (id)init
{
    if ((self = [super init])) {
        [self addOverlay];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addOverlay];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect innerRect = CGRectInset(rect, kOffRect, kOffRect);
    CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
    if (innerRect.size.width != minSize) {
        innerRect.origin.x += ((rect.size.width - minSize) / 2 - kOffRect);
        innerRect.size.width = minSize;
    }
    else if (innerRect.size.height != minSize) {
        innerRect.origin.y += (rect.size.height - minSize) / 2 - rect.size.height / 6;
        innerRect.size.height = minSize;
    }
    CGRect offsetRect = CGRectOffset(innerRect, 15, 15);
    _overlay.path = [UIBezierPath bezierPathWithRect:offsetRect].CGPath;
    
    CGFloat corWidth = 16;
    
    if (self.img1) {
        [self.img1 removeFromSuperview];
    }
    if (self.img2) {
        [self.img2 removeFromSuperview];
    }
    if (self.img3) {
        [self.img3 removeFromSuperview];
    }
    if (self.img4) {
        [self.img4 removeFromSuperview];
    }
    self.img1 = [[UIImageView alloc] initWithFrame:CGRectMake(offsetRect.origin.x - 1, offsetRect.origin.y, corWidth, corWidth)];
    _img1.image = [UIImage imageNamed:@"gyhs_leftTopCorner"];
    [self addSubview:_img1];
    
    self.img2 = [[UIImageView alloc] initWithFrame:CGRectMake(offsetRect.origin.x + offsetRect.size.width - 15, offsetRect.origin.y, corWidth, corWidth)];
    _img2.image = [UIImage imageNamed:@"gyhs_rightTopCorner"];
    
    [self addSubview:_img2];
    
    self.img3 = [[UIImageView alloc] initWithFrame:CGRectMake(offsetRect.origin.x - 1, offsetRect.origin.y + offsetRect.size.width - 16, corWidth, corWidth)];
    _img3.image = [UIImage imageNamed:@"gyhs_leftBottomCorner"];
    [self addSubview:_img3];
    
    self.img4 = [[UIImageView alloc] initWithFrame:CGRectMake(offsetRect.origin.x + offsetRect.size.width - 15, offsetRect.origin.y + offsetRect.size.width - 16, corWidth, corWidth)];
    _img4.image = [UIImage imageNamed:@"gyhs_rightBottomCorner"];
    [self addSubview:_img4];
    
    [self addOtherLay:offsetRect];
}

#pragma mark - Private Methods
- (void)addOtherLay:(CGRect)rect
{
    CAShapeLayer* layerTop = [[CAShapeLayer alloc] init];
    layerTop.fillColor = [UIColor blackColor].CGColor;
    layerTop.opacity = 0.5;
    layerTop.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, rect.origin.y)].CGPath;
    [self.layer addSublayer:layerTop];
    
    CAShapeLayer* layerLeft = [[CAShapeLayer alloc] init];
    layerLeft.fillColor = [UIColor blackColor].CGColor;
    layerLeft.opacity = 0.5;
    layerLeft.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.origin.y, rect.origin.x, [UIScreen mainScreen].bounds.size.height)].CGPath;
    [self.layer addSublayer:layerLeft];
    
    CAShapeLayer* layerRight = [[CAShapeLayer alloc] init];
    layerRight.fillColor = [UIColor blackColor].CGColor;
    layerRight.opacity = 0.5;
    layerRight.path = [UIBezierPath bezierPathWithRect:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, ([UIScreen mainScreen].bounds.size.width - rect.size.width) * 0.5, [UIScreen mainScreen].bounds.size.height)].CGPath;
    [self.layer addSublayer:layerRight];
    
    CAShapeLayer* layerBottom = [[CAShapeLayer alloc] init];
    layerBottom.fillColor = [UIColor blackColor].CGColor;
    layerBottom.opacity = 0.5;
    layerBottom.path = [UIBezierPath bezierPathWithRect:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, [UIScreen mainScreen].bounds.size.height - rect.origin.y - rect.size.height)].CGPath;
    [self.layer addSublayer:layerBottom];
}

- (void)addOverlay
{
    _overlay = [[CAShapeLayer alloc] init];
    _overlay.backgroundColor = [UIColor redColor].CGColor;
    _overlay.fillColor = [UIColor clearColor].CGColor;
    _overlay.strokeColor = [UIColor lightGrayColor].CGColor;
    _overlay.lineWidth = 1;
    _overlay.lineDashPattern = @[ @50, @0 ];
    _overlay.lineDashPhase = 1;
    _overlay.opacity = 0.5;
    [self.layer addSublayer:_overlay];
}

@end
