//
//  GYRandomCodeView.m
//
//  Created by zxm on 16/1/4.
//  生成验证码

#import "GYRandomCodeView.h"

@interface GYRandomCodeView () {
    UITapGestureRecognizer* _tap;
}
//验证码字符数
@property (nonatomic) NSUInteger count;

@end

@implementation GYRandomCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buidView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self buidView];
}

- (void)buidView
{
    self.count = 4;

    self.bgColor = [UIColor whiteColor];
    self.randColor = YES;
    self.interferingLine = YES;
    self.interferingPoint = NO;
    self.randColor = YES;

    _currentVerifyCode = [self randomCode];
    self.backgroundColor = self.bgColor;
    [self setNeedsDisplay];
}

- (UIColor*)randomColor
{
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor* randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];

    if (!self.randColor) {
        randColor = [UIColor blackColor];
    }

    return randColor;
}

- (NSString*)randomCode
{
    //return [self randomChar];
    return [self randomNumber];
}

- (NSString*)randomChar
{
    //数字: 48-57
    //小写字母: 97-122
    //大写字母: 65-90
    char chars[] = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLOMNOPQRSTUVWXYZ";
    char codes[self.count];

    for (int i = 0; i < self.count; i++) {
        codes[i] = chars[arc4random() % 62];
    }

    NSString* text = [[NSString alloc] initWithBytes:codes
                                              length:self.count
                                            encoding:NSUTF8StringEncoding];
    return text;
}

- (NSString*)randomNumber
{
    //数字: 48-57
    char chars[] = "1234567890";
    char codes[self.count];

    for (int i = 0; i < self.count; i++) {
        codes[i] = chars[arc4random() % 10];
    }

    NSString* text = [[NSString alloc] initWithBytes:codes
                                              length:self.count
                                            encoding:NSUTF8StringEncoding];
    return text;
}

- (void)generateCode:(UITapGestureRecognizer*)tap
{
    _currentVerifyCode = [self randomCode];
    self.backgroundColor = self.bgColor;
    [self setNeedsDisplay];
}

- (NSString*)refreshVerifyCode
{
    _currentVerifyCode = [self randomCode];
    self.backgroundColor = self.bgColor;
    [self setNeedsDisplay];

    return _currentVerifyCode;
}

- (void)didChangeCode:(DidChangeCode)didChangeCode
{
    if (didChangeCode) {
        _didChangeCode = [didChangeCode copy];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    NSString* text = _currentVerifyCode;

    //生成文字
    if (_didChangeCode) {
        _didChangeCode(text);
    }
    CGSize charSize = [@"A" sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15.0] }];

    CGPoint point;
    float pointX, pointY;

    //左右边距
    CGFloat Xoffset = self.frame.size.width / text.length * 0.5;

    int width = (self.frame.size.width - 2 * Xoffset) / text.length - charSize.width;
    int height = self.frame.size.height - charSize.height;

    if (width <= 0) {
        width = 1;
    }

    for (int i = 0; i < text.length; i++) {
        //pointX = arc4random() % width + self.frame.size.width / text.length * i;
        pointX = Xoffset + arc4random() % width + (self.frame.size.width - 2 * Xoffset) / text.length * i;

        pointY = height / 2;
        float fontSize = 15;

        if (self.randColor) {
            pointY = arc4random() % height;
            fontSize = (arc4random() % 10) + 15;
        }

        point = CGPointMake(pointX, pointY);
        unichar c = [text characterAtIndex:i];
        NSString* textChar = [NSString stringWithFormat:@"%C", c];
        CGContextSetLineWidth(context, 1.0);

        [textChar drawAtPoint:point withAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize], NSStrokeColorAttributeName : kNavigationBarColor, NSForegroundColorAttributeName : [self randomColor] }];
    }

    //干扰线
    if (self.interferingLine) {
        CGContextSetLineWidth(context, 1.0);
        for (int i = 0; i < self.count; i++) {
            CGContextSetStrokeColorWithColor(context, [[self randomColor] CGColor]);
            pointX = arc4random() % (int)self.frame.size.width;
            pointY = arc4random() % (int)self.frame.size.height;
            CGContextMoveToPoint(context, pointX, pointY);
            pointX = arc4random() % (int)self.frame.size.width;
            pointY = arc4random() % (int)self.frame.size.height;
            CGContextAddLineToPoint(context, pointX, pointY);
            CGContextStrokePath(context);
        }
    }

    //干扰点
    if (self.interferingPoint) {
        for (int i = 0; i < self.count * 6; i++) {
            CGContextSetStrokeColorWithColor(context, [[self randomColor] CGColor]);
            pointX = arc4random() % (int)self.frame.size.width;
            pointY = arc4random() % (int)self.frame.size.height;
            CGContextMoveToPoint(context, pointX, pointY);
            CGContextAddLineToPoint(context, pointX + 1, pointY + 1);

            CGContextStrokePath(context);
        }
    }
}

@end
