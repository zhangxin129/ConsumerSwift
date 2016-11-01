//
//  GYHSAccountCenter.h
//  HSCompanyPad
//
//  Created by sqm on 16/8/30.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//企业账户里面用到的数据汇总出一个类

#import <Foundation/Foundation.h>

@interface GYHSAccountCenter : NSObject
+ (instancetype)defaultCenter;
/**
 *  积分账户
 */
@property (nonatomic, copy) NSString *accountBalance;
@property (nonatomic, copy) NSString *canUsePoints;
@property (nonatomic, copy) NSString *yesterdayPoints;
@property (nonatomic, copy) NSString *ltbBalance;
@property (nonatomic, copy) NSString *csBalance;
@property (nonatomic, copy) NSString *cashBanlance;
@property (nonatomic, copy) NSString *accumulativeInvestCount;
@property (nonatomic, copy) NSString *totalDividend; //本年度投资分红互生币
@property (nonatomic, copy) NSString *normalDividend;//其中流通币
@property (nonatomic, copy) NSString *directionalDividend;//其中慈善救助基金
@property (nonatomic, copy) NSString *dividendYear;//投资年度
@property (nonatomic, copy) NSString *yearDividendRate;//投资回报率


/**
 *  余额更新数据
 *
 *  @param success 成功
 *  @param failure 失败
 */
- (void)updatePointAccount:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)updateCashAccount:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)updateHsbAccount:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)updateInvestAccount:(SuccessBlock)success failure:(FailureBlock)failure;
@end
