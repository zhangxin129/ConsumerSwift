//
//  GYHSInvestBonusDividendModel.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/9/19.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
@interface GYHSInvestBonusDividendModel : JSONModel

@property (nonatomic, copy) NSString *totalDividend;//分红合计
@property (nonatomic, copy) NSString *investNo;
@property (nonatomic, copy) NSString *investDate;//投资日期
@property (nonatomic, copy) NSString *dividendDays;//可参与分红天数
@property (nonatomic, copy) NSString *normalDividend;//流通币
@property (nonatomic, copy) NSString *dividendNo;
@property (nonatomic, copy) NSString *directionalDividend;//慈善基金
@property (nonatomic, copy) NSString *investAmount;//投资积分数

@end
