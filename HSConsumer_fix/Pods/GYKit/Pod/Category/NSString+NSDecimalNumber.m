//
//  NSString+NSDecimalNumber.m
//  WUBBTEXT
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NSString+NSDecimalNumber.h"

@implementation NSString (NSDecimalNumber)

//NSString类型转NSDecimalNumber，保留原有位数
- (NSDecimalNumber*)stringchageToNSDecimalNumber
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        decimalNumber = [NSDecimalNumber decimalNumberWithString:self];
    }
    return decimalNumber;
}

//NSString类型转NSDecimalNumber并且保留两位小数（四舍五入）
- (NSDecimalNumber*)stringChageToTwodecimalplaces
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* zero = [NSDecimalNumber decimalNumberWithString:@"0"];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        decimalNumber = [strDecimalNumber decimalNumberByAdding:zero withBehavior:kRoundBankers];
    }
    return decimalNumber;
}

//NSString类型转NSDecimalNumber并且保留两位小数（只舍不入）
- (NSDecimalNumber*)stringChageToTwoDowndecimalplaces
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* zero = [NSDecimalNumber decimalNumberWithString:@"0"];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        decimalNumber = [strDecimalNumber decimalNumberByAdding:zero withBehavior:KRoundDown];
    }
    return decimalNumber;
};

//NSString类型转NSDecimalNumber并且保留两位小数（只入不舍）
- (NSDecimalNumber*)stringChageToTwoUpdecimalplaces
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* zero = [NSDecimalNumber decimalNumberWithString:@"0"];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        decimalNumber = [strDecimalNumber decimalNumberByAdding:zero withBehavior:KRoundUp];
    }
    return decimalNumber;
};

//NSString类型转NSDecimalNumber的加法,保留原有位数
- (NSDecimalNumber*)stringAddString:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 && str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberByAdding:strDecimalNumber];
    }
    return decimalNumber;
}

//NSString类型转NSDecimalNumber的加法并且保留两位小数（四舍五入）
- (NSDecimalNumber*)stringAddStringToTwodecimalplaces:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 && str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberByAdding:strDecimalNumber withBehavior:kRoundBankers];
    }
    return decimalNumber;
}

//NSString类型转NSDecimalNumber的加法并且保留两位小数（只舍不入）
- (NSDecimalNumber*)stringAddStringToDownTwodecimalplaces:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 && str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberByAdding:strDecimalNumber withBehavior:KRoundDown];
    }
    return decimalNumber;
};

//NSString类型转NSDecimalNumber的加法并且保留两位小数（只入不舍）
- (NSDecimalNumber*)stringAddStringToUpTwodecimalplaces:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 && str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberByAdding:strDecimalNumber withBehavior:KRoundUp];
    }
    return decimalNumber;
};

//NSString类型转NSDecimalNumber的减法,保留原有位数
- (NSDecimalNumber*)stringSubtractString:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 && str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberBySubtracting:strDecimalNumber];
    }
    return decimalNumber;
}

//NSString类型转NSDecimalNumber的减法并且保留两位小数（四舍五入）
- (NSDecimalNumber*)stringSubtractStringToTwodecimalplaces:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 && str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberBySubtracting:strDecimalNumber withBehavior:kRoundBankers];
    }
    return decimalNumber;
}

//NSString类型转NSDecimalNumber的减法并且保留两位小数（只舍不入）
- (NSDecimalNumber*)stringSubtractStringToDownTwodecimalplaces:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 && str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberBySubtracting:strDecimalNumber withBehavior:KRoundDown];
    }
    return decimalNumber;
};

//NSString类型转NSDecimalNumber的减法并且保留两位小数（只入不舍）
- (NSDecimalNumber*)stringSubtractStringToUpTwodecimalplaces:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 && str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberBySubtracting:strDecimalNumber withBehavior:KRoundUp];
    }
    return decimalNumber;
};
//NSString类型转NSDecimalNumber的乘法,保留原有位数
- (NSDecimalNumber*)stringMultiplyString:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 || str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberByMultiplyingBy:strDecimalNumber];
    }
    return decimalNumber;
}

//NSString类型转NSDecimalNumber的乘法并且保留两位小数（四舍五入）
- (NSDecimalNumber*)stringMultiplyStringToTwodecimalplaces:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 || str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberByMultiplyingBy:strDecimalNumber withBehavior:kRoundBankers];
    }
    return decimalNumber;
}

//NSString类型转NSDecimalNumber的乘法并且保留两位小数（只舍不入）
- (NSDecimalNumber*)stringMultiplyStringToDownTwodecimalplaces:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 || str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberByMultiplyingBy:strDecimalNumber withBehavior:KRoundDown];
    }
    return decimalNumber;
};

//NSString类型转NSDecimalNumber的乘法并且保留两位小数（只入不舍）
- (NSDecimalNumber*)stringMultiplyStringToUpTwodecimalplaces:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 || str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        decimalNumber = [selfStrDecimalNumber decimalNumberByMultiplyingBy:strDecimalNumber withBehavior:KRoundUp];
    }
    return decimalNumber;
};

//NSString类型转NSDecimalNumber的除法,保留原有位数
- (NSDecimalNumber*)stringDividString:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 || str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        if (strDecimalNumber != [NSDecimalNumber zero]) {
            decimalNumber = [selfStrDecimalNumber decimalNumberByDividingBy:strDecimalNumber];
        }
    }
    return decimalNumber;
}

//NSString类型转NSDecimalNumber的除法并且保留两位小数（四舍五入）
- (NSDecimalNumber*)stringDividStringToTwodecimalplaces:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 || str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        if (strDecimalNumber != [NSDecimalNumber zero]) {
            decimalNumber = [selfStrDecimalNumber decimalNumberByDividingBy:strDecimalNumber withBehavior:kRoundBankers];
        }
    }
    return decimalNumber;
}
//NSString类型转NSDecimalNumber的除法并且保留两位小数（只舍不入）
- (NSDecimalNumber*)stringDividStringToDownTwodecimalplaces:(NSString*)str
{
    NSDecimalNumber* decimalNumber;
    if (self.length == 0 || str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }
    else {
        NSDecimalNumber* selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber* strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        if (strDecimalNumber != [NSDecimalNumber zero]) {
            decimalNumber = [selfStrDecimalNumber decimalNumberByDividingBy:strDecimalNumber withBehavior:KRoundDown];
        }
    }
    return decimalNumber;
};

//NSString类型转NSDecimalNumber的除法并且保留两位小数（只入不舍）
- (NSDecimalNumber *)stringDividStringToUpTwodecimalplaces:(NSString *)str{
    NSDecimalNumber *decimalNumber;
    if (self.length == 0 || str.length == 0) {
        decimalNumber = [NSDecimalNumber zero];
    }else{
        NSDecimalNumber *selfStrDecimalNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber *strDecimalNumber = [NSDecimalNumber decimalNumberWithString:str];
        if (strDecimalNumber != [NSDecimalNumber zero]) {
            decimalNumber = [selfStrDecimalNumber decimalNumberByDividingBy:strDecimalNumber withBehavior:KRoundUp];
        }
    }
    return decimalNumber;
};

@end

