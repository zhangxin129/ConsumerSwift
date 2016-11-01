//
//  Utils.m
//  HSConsumer
//
//  Created by apple on 14-10-9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYUtils.h"

@implementation GYUtils
+ (BOOL)isHSCardNo:(NSString*)cardNo
{
    NSString* regex = @"^[0-9]{11}$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:cardNo];
    if (!isMatch)
        return NO;

    NSString* cardNo1 = [cardNo substringWithRange:NSMakeRange(0, 2)];
    NSString* cardNo2 = [cardNo substringWithRange:NSMakeRange(2, 3)];
    NSString* cardNo3 = [cardNo substringWithRange:NSMakeRange(5, 2)];
    NSString* cardNo4 = [cardNo substringWithRange:NSMakeRange(7, 4)];

    if ([cardNo1 intValue] <= 0 ||
        [cardNo2 intValue] <= 0 ||
        [cardNo3 intValue] <= 0 ||
        [cardNo4 intValue] <= 0) {
        return NO;
    }
    return YES;
}

+ (NSString*)formatCardNo:(NSString*)cardNo
{
    if (cardNo.length != 11)
        return cardNo;
    NSString* cardNo1 = [cardNo substringWithRange:NSMakeRange(0, 2)];
    NSString* cardNo2 = [cardNo substringWithRange:NSMakeRange(2, 3)];
    NSString* cardNo3 = [cardNo substringWithRange:NSMakeRange(5, 2)];
    NSString* cardNo4 = [cardNo substringWithRange:NSMakeRange(7, 4)];
    NSString* formatCardNo = [NSString stringWithFormat:@"%@ %@ %@ %@", cardNo1, cardNo2, cardNo3, cardNo4];
    return formatCardNo;
}
+ (NSString*)getRandomString:(int)length
{
    const char list[] = "0123456789";
    char sele[24], *p;
    p = sele;
    int len = (int)strlen(list);
    for (int i = 0; i < length; i++) {
        *p++ = list[arc4random() % len];
    }
    *p = 0;
    NSString* str = [NSString stringWithFormat:@"%s", sele];
    return str;
}

+ (NSString*)formatCurrencyStyle:(double)val
{
    if (val < 0.0001) {
        return @"0.00";
    }

    //自定义方式
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0.00"]; //@"$#,###0.00"    format:12345678.987 =912,345,678.10
    //    [numberFormatter setPositiveFormat:@"0,000.##"];//@"$#,###0.00"    format:12345678.987 =912,345,678.10
    NSString* formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:val]];

    //    NSString *formattedNumberString = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:[number doubleValue]]
    //                                                                         numberStyle:NSNumberFormatterCurrencyStyle];//本地化货币显示
    return formattedNumberString;
}

+ (UIImage*)createQRImageWithString:(NSString*)qrString size:(CGSize)size
{

    // Need to convert the string to a UTF-8 encoded NSData object
    NSData* stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter* qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];

    CGRect extent = CGRectIntegral(qrFilter.outputImage.extent);
    CGFloat scale = MIN(size.width / CGRectGetWidth(extent), size.height / CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext* context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:qrFilter.outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (NSString*)dateToString:(NSDate*)date
{
    return [self dateToString:date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString*)dateToString:(NSDate*)date dateFormat:(NSString*)dateFormat
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:dateFormat];
    NSString* dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

// 拨打号码
+ (void)callPhoneWithPhoneNumber:(NSString*)phoneNumber showInView:(UIView*)view
{
    if (phoneNumber.length == 0) {
        //        [[self class] showToast:];
        return;
    }
    UIWebView* callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]]]];
    [view addSubview:callWebview];
}

+ (void)showToast:(NSString*)text
{
    [[UIApplication sharedApplication].keyWindow makeToast:text duration:1.f position:CSToastPositionBottom];
}

+ (void)showToast:(NSString*)text duration:(NSTimeInterval)duration position:(id)position
{
    [[UIApplication sharedApplication].keyWindow makeToast:text duration:duration position:position];
}

+(void)showToast:(UIView*)toast duration:(NSTimeInterval)duration  position:(id)position   completion:(void (^)(BOOL didTap))completion
{
    
 [[UIApplication sharedApplication].keyWindow showToast:toast duration:duration position:position completion:completion];

}

+ (NSInteger)saftToNSInteger:(id)idVaule
{
    if ([idVaule isKindOfClass:[NSNumber class]]) {
        return [idVaule integerValue];
    }
    return [[self saftToNSString:idVaule] integerValue];
}

+ (NSString*)saftToNSString:(id)idVaule
{
    if ([idVaule isKindOfClass:[NSString class]]) {

        return idVaule;
    }
    else if (!idVaule || [idVaule isKindOfClass:[NSNull class]]) { //空
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@", idVaule];
}

@end
