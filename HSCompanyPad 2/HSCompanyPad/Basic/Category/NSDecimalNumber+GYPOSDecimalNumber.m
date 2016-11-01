//
//  NSDecimalNumber+GYPOSDecimalNumber.m
//  company
//
//  Created by 梁晓辉 on 16/6/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "NSDecimalNumber+GYPOSDecimalNumber.h"

@implementation NSDecimalNumber (GYPOSDecimalNumber)
- (NSDecimalNumber *)keepTwoScale
{
    
    return  [self decimalNumberByRoundingAccordingToBehavior:[self roundMode:NSRoundPlain]];
}

- (NSDecimalNumber *)keepTwoScaleRoundUp
{
  
    return  [self decimalNumberByRoundingAccordingToBehavior:[self roundMode:NSRoundUp]];
}

- (NSDecimalNumber *)keepTwoScaleRoundDown
{
    return  [self decimalNumberByRoundingAccordingToBehavior:[self roundMode:NSRoundDown]];
}

- (NSDecimalNumberHandler *)roundMode:(NSRoundingMode)mode
{
    return [self roundMode:mode scale:2];
}

- (NSDecimalNumberHandler *)roundMode:(NSRoundingMode)mode scale:(NSInteger)scale
{
    NSDecimalNumberHandler*handler = [NSDecimalNumberHandler
                                     decimalNumberHandlerWithRoundingMode:mode
                                     scale:scale
                                     raiseOnExactness:NO
                                     raiseOnOverflow:YES
                                     raiseOnUnderflow:YES
                                     raiseOnDivideByZero:YES];
    return handler;
}

- (NSDecimalNumber *)roundCustomedScale:(NSInteger)scale
{
    return [self roundCustomedScale:scale mode:NSRoundPlain];

}

- (NSDecimalNumber *)roundCustomedScale:(NSUInteger)scale mode:(NSRoundingMode)mode
{
    NSDecimalNumberHandler * hander = [self roundMode:mode scale:scale];
    return [self decimalNumberByRoundingAccordingToBehavior:hander];

}

- (NSDecimalNumber *)operatDecimal:(NSDecimalNumber *)decimalNumber type:(calculationType)type
{
        
    
       switch (type) {
        case kDecimalAdd:
            return [self decimalNumberByAdding:decimalNumber];
            break;
        case kDecimalSubtract:
            return [self decimalNumberBySubtracting:decimalNumber];
        case kDecimalMultiplication:
            return [self decimalNumberByMultiplyingBy:decimalNumber];
        case kDecimalDivid:
            return [self decimalNumberByDividingBy:decimalNumber];
        default:
            break;
    }
}

- (NSDecimalNumber *)operatDecimal:(NSDecimalNumber *)decimalNumber type:(calculationType)type behavior:(NSDecimalNumberHandler *)hander
{
    switch (type) {
        case kDecimalAdd:
            return [self decimalNumberByAdding:decimalNumber withBehavior:hander];
            break;
        case kDecimalSubtract:
            return [self decimalNumberBySubtracting:decimalNumber withBehavior:hander];
        case kDecimalMultiplication:
            return [self decimalNumberByMultiplyingBy:decimalNumber withBehavior:hander];
        case kDecimalDivid:
            return [self decimalNumberByDividingBy:decimalNumber withBehavior:hander];
        default:
            break;
    }
}

- (NSComparisonResult)decimalString:(NSString *)decimalString otherDecimalString:(NSString *)otherDecimalString;
{
    NSDecimalNumber * discountOne = [NSDecimalNumber decimalNumberWithString:decimalString];
    
    NSDecimalNumber*discountTwo = [NSDecimalNumber decimalNumberWithString:otherDecimalString];
    
   return [discountOne compare:discountTwo];
    
}

- (NSDecimalNumber*)discountDecimalNumber:(float)percent
{
    NSDecimalNumber * transPercent = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:percent] decimalValue]];
    return [self decimalNumberByMultiplyingBy:transPercent];
}

@end
