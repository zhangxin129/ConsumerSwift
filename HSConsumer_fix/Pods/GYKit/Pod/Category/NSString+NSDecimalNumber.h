//
//  NSString+NSDecimalNumber.h
//  WUBBTEXT
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
//将NSDecimalNumber类型的数据结果保留小数点后两位(四舍五入)
#define kRoundBankers [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:YES raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES]

//将NSDecimalNumber类型的数据结果保留小数点后两位(只舍不入)
#define KRoundDown [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:YES raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES]

//将NSDecimalNumber类型的数据结果保留小数点后两位(只入不舍)
#define KRoundUp [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:2 raiseOnExactness:YES raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES]

@interface NSString (NSDecimalNumber)
//NSString类型转NSDecimalNumber，保留原有位数
- (NSDecimalNumber*)stringchageToNSDecimalNumber;

//NSString类型转NSDecimalNumber并且保留两位小数（四舍五入）
- (NSDecimalNumber*)stringChageToTwodecimalplaces;

//NSString类型转NSDecimalNumber并且保留两位小数（只舍不入）
- (NSDecimalNumber*)stringChageToTwoDowndecimalplaces;

//NSString类型转NSDecimalNumber并且保留两位小数（只入不舍）
- (NSDecimalNumber*)stringChageToTwoUpdecimalplaces;

//NSString类型转NSDecimalNumber的加法,保留原有位数
- (NSDecimalNumber*)stringAddString:(NSString*)str;

//NSString类型转NSDecimalNumber的加法并且保留两位小数（四舍五入）
- (NSDecimalNumber*)stringAddStringToTwodecimalplaces:(NSString*)str;

//NSString类型转NSDecimalNumber的加法并且保留两位小数（只舍不入）
- (NSDecimalNumber*)stringAddStringToDownTwodecimalplaces:(NSString*)str;

//NSString类型转NSDecimalNumber的加法并且保留两位小数（只入不舍）
- (NSDecimalNumber*)stringAddStringToUpTwodecimalplaces:(NSString*)str;

//NSString类型转NSDecimalNumber的减法,保留原有位数
- (NSDecimalNumber*)stringSubtractString:(NSString*)str;

//NSString类型转NSDecimalNumber的减法并且保留两位小数（四舍五入）
- (NSDecimalNumber*)stringSubtractStringToTwodecimalplaces:(NSString*)str;

//NSString类型转NSDecimalNumber的减法并且保留两位小数（只舍不入）
- (NSDecimalNumber*)stringSubtractStringToDownTwodecimalplaces:(NSString*)str;

//NSString类型转NSDecimalNumber的减法并且保留两位小数（只入不舍）
- (NSDecimalNumber*)stringSubtractStringToUpTwodecimalplaces:(NSString*)str;

//NSString类型转NSDecimalNumber的乘法,保留原有位数
- (NSDecimalNumber*)stringMultiplyString:(NSString*)str;

//NSString类型转NSDecimalNumber的乘法并且保留两位小数（四舍五入）
- (NSDecimalNumber*)stringMultiplyStringToTwodecimalplaces:(NSString*)str;

//NSString类型转NSDecimalNumber的乘法并且保留两位小数（只舍不入）
- (NSDecimalNumber*)stringMultiplyStringToDownTwodecimalplaces:(NSString*)str;

//NSString类型转NSDecimalNumber的乘法并且保留两位小数（只入不舍）
- (NSDecimalNumber *)stringMultiplyStringToUpTwodecimalplaces:(NSString *)str;

//NSString类型转NSDecimalNumber的除法,保留原有位数
- (NSDecimalNumber *)stringDividString:(NSString *)str;

//NSString类型转NSDecimalNumber的除法并且保留两位小数（四舍五入）
- (NSDecimalNumber *)stringDividStringToTwodecimalplaces:(NSString *)str;

//NSString类型转NSDecimalNumber的除法并且保留两位小数（只舍不入）
- (NSDecimalNumber *)stringDividStringToDownTwodecimalplaces:(NSString *)str;

//NSString类型转NSDecimalNumber的除法并且保留两位小数（只入不舍）
- (NSDecimalNumber *)stringDividStringToUpTwodecimalplaces:(NSString *)str;

@end
