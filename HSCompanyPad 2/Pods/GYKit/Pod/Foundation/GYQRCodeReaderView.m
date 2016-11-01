/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "GYQRCodeReaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface GYQRCodeReaderView ()
@property (nonatomic, strong) CAShapeLayer* overlay;
@end

@implementation GYQRCodeReaderView


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self addOverlay];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect innerRect = CGRectInset(rect, 50, 50);//通过 第二个参数 dx和第三个参数 dy 重置第一个参数rect 作为结果返回。重置的方式为，首先将rect 的坐标（origin）按照（dx,dy) 进行平移，然后将rect的大小（size） 宽度缩小2倍的dx，高度缩小2倍的dy；
    
    CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
    if (innerRect.size.width != minSize) {
        innerRect.origin.x += 50;
        innerRect.size.width = minSize;
    }
    else if (innerRect.size.height != minSize) {
        innerRect.origin.y += (rect.size.height - minSize) / 2 - rect.size.height / 6;
        innerRect.size.height = minSize;
    }
    CGRect offsetRect = CGRectOffset(innerRect, 0, 15);
    
    self.innerViewRect = offsetRect;
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadView:)]) {
        [self.delegate loadView:self.innerViewRect];
    }
    _overlay.path = [UIBezierPath bezierPathWithRect:offsetRect].CGPath;
    
    CGFloat corWidth = 16;
    
    UIImageView* img1 = [[UIImageView alloc] initWithFrame:CGRectMake(49, offsetRect.origin.y, corWidth, corWidth)];
    img1.image = [UIImage imageNamed:@"GYFoundation.bundle/QRCodeScanCor1"];
    [self addSubview:img1];
    
    UIImageView* img2 = [[UIImageView alloc] initWithFrame:CGRectMake(35 + offsetRect.size.width, offsetRect.origin.y, corWidth, corWidth)];
    img2.image = [UIImage imageNamed:@"GYFoundation.bundle/QRCodeScanCor2"];
    
    [self addSubview:img2];
    
    UIImageView* img3 = [[UIImageView alloc] initWithFrame:CGRectMake(49, offsetRect.origin.y + offsetRect.size.width - 16, corWidth, corWidth)];
    img3.image = [UIImage imageNamed:@"GYFoundation.bundle/QRCodeScanCor3"];
    [self addSubview:img3];
    
    UIImageView* img4 = [[UIImageView alloc] initWithFrame:CGRectMake(35 + offsetRect.size.width, offsetRect.origin.y + offsetRect.size.width - 16, corWidth, corWidth)];
    img4.image = [UIImage imageNamed:@"GYFoundation.bundle/QRCodeScanCor4"];
    [self addSubview:img4];
    
    [self addOtherLay:offsetRect];
}

#pragma mark - Private Methods

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
    layerLeft.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.origin.y, 50, [UIScreen mainScreen].bounds.size.height)].CGPath;
    [self.layer addSublayer:layerLeft];
    
    CAShapeLayer* layerRight = [[CAShapeLayer alloc] init];
    layerRight.fillColor = [UIColor blackColor].CGColor;
    layerRight.opacity = 0.5;
    layerRight.path = [UIBezierPath bezierPathWithRect:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, rect.origin.y, 50, [UIScreen mainScreen].bounds.size.height)].CGPath;
    [self.layer addSublayer:layerRight];
    
    CAShapeLayer* layerBottom = [[CAShapeLayer alloc] init];
    layerBottom.fillColor = [UIColor blackColor].CGColor;
    layerBottom.opacity = 0.5;
    layerBottom.path = [UIBezierPath bezierPathWithRect:CGRectMake(50, rect.origin.y + rect.size.height, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - rect.origin.y - rect.size.height)].CGPath;
    [self.layer addSublayer:layerBottom];
}
@end
