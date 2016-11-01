//
//  GYHSInvestDividendModel.h
//  HSCompanyPad
//
//  Created by sqm on 16/8/31.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSInvestDividendModel : NSObject
/**
 *  分红年份
 */
@property (nonatomic, copy) NSString *dividendYear;
/**
 *  分红回报率
 */
@property (nonatomic, copy) NSString *dividendRate;
@end
