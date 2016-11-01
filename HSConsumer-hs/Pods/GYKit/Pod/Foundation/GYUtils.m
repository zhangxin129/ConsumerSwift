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

+ (UIImage*)creatBarCodeWithString:(NSString*)barCodeStr size:(CGSize)size
{
    //生成条形码图片
    CIImage* barcodeImage;
    NSData* data = [barCodeStr dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter* filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    //[filter setValue:@(0.00) forKey:@"inputQuietSpace"];
    barcodeImage = [filter outputImage];

    //消除模糊
    CGFloat scaleX = size.width / barcodeImage.extent.size.width;
    CGFloat scaleY = size.height / barcodeImage.extent.size.height;
    CIImage* transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, scaleX, scaleY)];

    return [UIImage imageWithCIImage:transformedImage];
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

+ (UIImage*)creatQRCodeWithURLString:(NSString*)urlString imageViewSize:(CGSize)imageViewSize logoImage:(UIImage*)logoImage logoImageSize:(CGSize)logoImageSize logoImageWithCornerRadius:(CGFloat)cornerRadius
{
    UIImage* qrImage = [self createQRImageWithString:urlString size:imageViewSize];

    if (logoImage != nil) {
        if (cornerRadius < 0) {
            cornerRadius = 0;
        }

        CGRect rect = CGRectMake((imageViewSize.width - logoImageSize.width) / 2, (imageViewSize.height - logoImageSize.height) / 2, logoImageSize.width, logoImageSize.height);
        qrImage = [self addImageToSuperImage:qrImage withSubImage:[self imageWithCornerRadius:cornerRadius image:logoImage] andSubImagePosition:rect]; // 增加logo
    }
    return qrImage;
}

/**
 *  图片增加水印
 *
 *  @param superImage 需要增加水印的图片
 *  @param subImage   水印图片
 *  @param posRect    水印的位置 和 水印的大小
 *
 *  @return 加水印后的新图片
 */
+ (UIImage*)addImageToSuperImage:(UIImage*)superImage withSubImage:(UIImage*)subImage andSubImagePosition:(CGRect)posRect
{

    UIGraphicsBeginImageContext(superImage.size);
    [superImage drawInRect:CGRectMake(0, 0, superImage.size.width, superImage.size.height)];
    //四个参数为水印图片的位置
    [subImage drawInRect:posRect];
    UIImage* resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

/**
 *  图片设置圆角
 *
 *  @param cornerRadius 圆角值
 *  @param original     图片
 *
 *  @return 圆角图片
 */
+ (UIImage*)imageWithCornerRadius:(CGFloat)cornerRadius image:(UIImage*)image
{
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    // 画图
    [image drawInRect:frame];
    // 获取新的图片
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return im;
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

+ (void)showToastOnKeyboard:(NSString*)text
{
    [[GYUtils findKeyboard] makeToast:text duration:1.f position:CSToastPositionBottom];
}
+ (UIView*)findKeyboard
{
    UIView* keyboardView = nil;
    NSArray* windows = [[UIApplication sharedApplication] windows];
    for (UIWindow* window in [windows reverseObjectEnumerator]) //逆序效率更高，因为键盘总在上方
    {
        keyboardView = [GYUtils findKeyboardInView:window];
        if (keyboardView) {
            return keyboardView;
        }
    }
    return nil;
}
+ (UIView*)findKeyboardInView:(UIView*)view
{
    for (UIView* subView in [view subviews]) {
        if (strstr(object_getClassName(subView), "UIKeyboard")) {
            return subView;
        }
        else {
            UIView* tempView = [self findKeyboardInView:subView];
            if (tempView) {
                return tempView;
            }
        }
    }
    return nil;
}

+ (void)showToast:(NSString*)text duration:(NSTimeInterval)duration position:(id)position
{
    [[UIApplication sharedApplication].keyWindow makeToast:text duration:duration position:position];
}

+ (void)showToast:(UIView*)toast duration:(NSTimeInterval)duration position:(id)position completion:(void (^)(BOOL didTap))completion
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

+ (NSString*)decimalNumberMutiplyWithString:(NSString*)multiplierValue othersString:(NSString*)multiplicandValue
{
    NSDecimalNumber* multiplierNumber = [NSDecimalNumber decimalNumberWithString:multiplierValue];
    NSDecimalNumber* multiplicandNumber = [NSDecimalNumber decimalNumberWithString:multiplicandValue];
    NSDecimalNumberHandler* roundBanker = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO]; //四舍五入保留小数点后两位
    NSDecimalNumber* totalValueNumber = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber withBehavior:roundBanker];
    return [NSString stringWithFormat:@"%.2f", [totalValueNumber doubleValue]];
}

@end
