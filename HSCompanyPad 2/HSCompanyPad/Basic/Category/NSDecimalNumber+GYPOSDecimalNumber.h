//
//  NSDecimalNumber+GYPOSDecimalNumber.h
//  company
//
//  Created by 梁晓辉 on 16/6/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, calculationType) {
    kDecimalAdd = 1,
    kDecimalSubtract = 2,
    kDecimalMultiplication = 3,
    kDecimalDivid = 4,
};

@interface NSDecimalNumber (GYPOSDecimalNumber)

//默认四舍五入，保留两位小数
- (NSDecimalNumber *)keepTwoScale;

//进一法
- (NSDecimalNumber *)keepTwoScaleRoundUp;

//舍掉最后一位
- (NSDecimalNumber *)keepTwoScaleRoundDown;

//自定义小数位数（默认NSRoundPlain）
- (NSDecimalNumber *)roundCustomedScale:(NSInteger)scale;

//自定义小数位数和NSRoundingMode
- (NSDecimalNumber *)roundCustomedScale:(NSUInteger)scale mode:(NSRoundingMode)mode;
- (NSDecimalNumberHandler *)roundMode:(NSRoundingMode)mode;
//两数运算
- (NSDecimalNumber *)operatDecimal:(NSDecimalNumber *)decimalNumber type:(calculationType)type;

//两数运算,自定义位数和模式
- (NSDecimalNumber *)operatDecimal:(NSDecimalNumber *)decimalNumber type:(calculationType)type behavior:(NSDecimalNumberHandler *)hander;

//两数比较大小
- (NSComparisonResult)decimalString:(NSString *)decimalString otherDecimalString:(NSString *)otherDecimalString;
//计算折扣后价格
- (NSDecimalNumber*)discountDecimalNumber:(float)percent;

//
@end
