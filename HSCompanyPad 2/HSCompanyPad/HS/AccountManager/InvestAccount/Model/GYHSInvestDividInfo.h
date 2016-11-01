//
//  GYHSInvestDividInfo.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/9/9.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
@interface GYHSInvestDividInfo : JSONModel
@property (nonatomic, copy) NSString *totalDividend;//本笔分红合计
@property (nonatomic, copy) NSString *normalDividend;//年度投资分红流通币
@property (nonatomic, copy) NSString *dividendPeriod;//分红周期
@property (nonatomic, copy) NSString *yearDividendRate;//年度分红回报率
@property (nonatomic, copy) NSString *dividendYear;//分红年份
@property (nonatomic, copy) NSString *accumulativeInvestCount;//累计投资积分数
@property (nonatomic, copy) NSString *directionalDividend;//年度投资分红定向消费币
@property (nonatomic, copy) NSString *dividendInvestTotal;

@end
