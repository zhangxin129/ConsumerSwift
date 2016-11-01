//
//  GYRoundProgressView.m
//  HSCompanyPad
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYRoundProgressView.h"
NSString * const GYRoundProgressAnimationKey = @"GYRoundProgressAnimationKey";
@interface GYCircularProgressView : UIView
@property (nonatomic, strong) UILabel *textLabel;

- (void)updateProgress:(CGFloat)progress;
- (CAShapeLayer *)shapeLayer;

@end


@interface GYRoundProgressView()
@property (nonatomic, strong) GYCircularProgressView *progressView;
@property (nonatomic, strong) NSTimer *valueLabelUpdateTimer;

@end
@implementation GYRoundProgressView
@synthesize tintColor = _tintColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedSetup];
    }
    return self;
}

- (void)sharedSetup {
    self.progressView = [[GYCircularProgressView alloc] initWithFrame:self.bounds];
    self.progressView.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self addSubview:self.progressView];
    
    [self resetDefaults];
}

- (void)resetDefaults {
    
    self.didSelectBlock	= nil;
    
    _progress = 0.0;
    self.borderWidth = 1.0f;
    self.lineWidth = 2.0f;
    
    [self tintColorDidChange];
}
#pragma mark - Public Accessors


- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.progressView.shapeLayer.borderWidth = borderWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.progressView.shapeLayer.lineWidth = lineWidth;
}

#pragma mark - Color

- (void)tintColorDidChange {
    if ([[self superclass] instancesRespondToSelector: @selector(tintColorDidChange)]) {
        [super tintColorDidChange];
    }
    
    UIColor *tintColor = self.tintColor;
    
    self.progressView.shapeLayer.strokeColor = tintColor.CGColor;
    self.progressView.shapeLayer.borderColor = tintColor.CGColor;
}

- (UIColor*) tintColor
{
    if (_tintColor == nil) {
      _tintColor = [UIColor colorWithRed: 0.0 green: 122.0/255.0 blue: 1.0 alpha: 1.0];
    }
    return _tintColor;
}

- (void) setTintColor:(UIColor *)tintColor
{
    [self willChangeValueForKey: @"tintColor"];
    _tintColor = tintColor;
    [self didChangeValueForKey: @"tintColor"];
    [self tintColorDidChange];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    self.progressView.frame = self.bounds;
    self.progressView.textLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}
#pragma mark - Progress Control

- (void)refreshProgress:(CGFloat)progress
 {
    
    progress = MAX( MIN(progress, 1.0), 0.0); // 0 ~ 1
    
    if (_progress == progress) {
        return;
    }
    
    [self stopAnimation];
    _progress = progress;
    [self.progressView updateProgress:_progress];
}


- (void)stopAnimation {
    [self.progressView.layer removeAnimationForKey:GYRoundProgressAnimationKey];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.progressView updateProgress:_progress];
}
@end

#pragma mark - UACircularProgressView

@implementation GYCircularProgressView

+ (Class)layerClass {
    return CAShapeLayer.class;
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 32.0)];
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = kPurple000024;
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        [self updateProgress:0];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.shapeLayer.cornerRadius = self.frame.size.width / 2.0f;
    self.shapeLayer.path = [self layoutPath].CGPath;
}

- (UIBezierPath *)layoutPath {
    const double TWO_M_PI = 2.0 * M_PI;
    const double startAngle = 0.75 * TWO_M_PI;
    const double endAngle = startAngle + TWO_M_PI;
    
    CGFloat width = self.frame.size.width;
    CGFloat borderWidth = self.shapeLayer.borderWidth;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                          radius:width/2.0f - borderWidth
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:YES];
}

- (void)updateProgress:(CGFloat)progress {
    [self updatePath:progress];
}

- (void)updatePath:(CGFloat)progress {
    [self.textLabel setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.shapeLayer.strokeEnd = progress;
    [CATransaction commit];
}


@end
