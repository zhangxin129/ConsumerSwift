//
//  GYHSIdentifyCode.m
//  HSEnterprise
//
//  Created by apple on 16/2/4.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHSIdentifyCode.h"

#define kRandomColor [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0];
#define kLineCount 4 //干扰线
#define kLineWidth 1.0 //干扰线的宽度
#define kCharCount 4 //验证码个数
#define kFontSize [UIFont systemFontOfSize:arc4random() % 5 + 17] //字体随机大小
#define kFontBoldSize [UIFont fontWithName:@"Helvetica-Bold" size:arc4random() % 5 + 17] //字体随机大进行加粗
#define kCodeStrColor [UIColor blackColor]
@implementation GYHSIdentifyCode

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        //随机背景颜色
        self.backgroundColor = [UIColor whiteColor];
        if (self.width < 80) {
            self.width = 80;
        }
        if (self.isNeedColor) {
            self.backgroundColor = kRandomColor;
        }
        //获得随机验证码
        [self getAuthcode];
    }
    return self;
}

#pragma mark 获得随机验证码
- (void)getAuthcode
{
    //字符串素材
//    _dataSource = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
     _dataSource = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    _authCodeStr = [[NSMutableString alloc] initWithCapacity:kCharCount];
    //随机从数组中选取需要个数的字符串，拼接为验证码字符串
    for (int i = 0; i < kCharCount; i++) {
        NSInteger index = arc4random() % (_dataSource.count - 1);
        NSString* tempStr = [_dataSource objectAtIndex:index];
        _authCodeStr = (NSMutableString*)[_authCodeStr stringByAppendingString:tempStr];
    }
    
    //setNeedsDisplay调用drawRect方法来实现view的绘制
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //设置随机背景颜色
    self.backgroundColor = [UIColor whiteColor];
    if (self.isNeedColor) {
        self.backgroundColor = kRandomColor;
    }
    
    //根据要显示的验证码字符串，根据长度，计算每个字符串显示的位置
    NSString* text = [NSString stringWithFormat:@"%@", _authCodeStr];
    
    CGSize cSize = [@"A" sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:22] }];
    
    int width = rect.size.width / text.length - cSize.width;
    int height = rect.size.height - cSize.height;
    
    CGPoint point;
    
    //依次绘制每一个字符,可以设置显示的每个字符的字体大小、颜色、样式
    float pX, pY;
    for (int i = 0; i < text.length; i++) {
        pX = arc4random() % width + rect.size.width / text.length * i;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        
        unichar c = [text characterAtIndex:i];
        NSString* textC = [NSString stringWithFormat:@"%C", c];
        
        [textC drawAtPoint:point withAttributes:@{ NSFontAttributeName : kFontBoldSize, NSForegroundColorAttributeName : kCodeStrColor }];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(context, kLineWidth);
    
    if (self.isNeedLine) {
        //绘制干扰线
        for (int i = 0; i < kLineCount; i++) {
            UIColor* color = kRandomColor;
            CGContextSetStrokeColorWithColor(context, color.CGColor); //设置线条填充色
            
            //设置线的起点
            pX = arc4random() % (int)rect.size.width;
            pY = arc4random() % (int)rect.size.height;
            CGContextMoveToPoint(context, pX, pY);
            //设置线终点
            pX = arc4random() % (int)rect.size.width;
            pY = arc4random() % (int)rect.size.height;
            CGContextAddLineToPoint(context, pX, pY);
            //画线
            CGContextStrokePath(context);
        }
    }
}

@end
