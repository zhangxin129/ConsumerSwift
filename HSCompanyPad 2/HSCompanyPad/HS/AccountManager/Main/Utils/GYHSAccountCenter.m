//
//  GYHSAccountCenter.m
//  HSCompanyPad
//
//  Created by sqm on 16/8/30.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSAccountCenter.h"
#import "GYHSAccountHttpTool.h"

@implementation GYHSAccountCenter

#pragma mark 单例
static id _instace;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _instace = [super allocWithZone:zone]; });
    return _instace;
}

+ (instancetype)defaultCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _accountBalance          = @"";
        _canUsePoints            = @"";
        _yesterdayPoints         = @"";
        _ltbBalance              = @"";
        _csBalance               = @"";
        _cashBanlance            = @"";
        _accumulativeInvestCount = @"";
        _totalDividend           = @"";
        _normalDividend          = @"";
        _directionalDividend     = @"";
        _dividendYear            = @"";
        _yearDividendRate        = @"";
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}

/**
 *  更新积分账户的余额数据
 *
 *  @param success 成功
 *  @param failure 失败
 */
- (void)updatePointAccount:(SuccessBlock)success failure:(FailureBlock)failure
{
    @weakify(self)
    [GYHSAccountHttpTool getAccountBalanceDetailWithAccCategory: @"1" success:^(id responsObject) {
        @strongify(self);
        self.accountBalance = kSaftToNSString(responsObject[kLocalized(@"accountBalance")]);
        self.canUsePoints = kSaftToNSString(responsObject[kLocalized(@"canUsePoints")]);
        self.yesterdayPoints = kSaftToNSString(responsObject[kLocalized(@"yesterdayPoints")]);
        KExcuteBlock(success, nil);
    } failure:^{
        KExcuteBlock(failure, nil);
    }];
}

/**
 *  更新货币账户的余额数据
 *
 *  @param success 成功
 *  @param failure 失败
 */
- (void)updateCashAccount:(SuccessBlock)success failure:(FailureBlock)failure
{
    @weakify(self)
    [GYHSAccountHttpTool getAccountBalanceDetailWithAccCategory: @"3" success:^(id responsObject) {
        @strongify(self);
        self.cashBanlance = kSaftToNSString(responsObject[kLocalized(@"accountBalance")]);

        KExcuteBlock(success, nil);
    } failure:^{
        KExcuteBlock(failure, nil);
    }];
}

/**
 *  更新互生币余额数据
 *
 *  @param success 成功
 *  @param failure 失败
 */
- (void)updateHsbAccount:(SuccessBlock)success failure:(FailureBlock)failure
{
    @weakify(self)
    [GYHSAccountHttpTool getAccountBalanceDetailWithAccCategory: @"2" success:^(id responsObject) {
        @strongify(self);

        self.ltbBalance = kSaftToNSString(responsObject[kLocalized(@"ltbBalance")]);
        self.csBalance = kSaftToNSString(responsObject[kLocalized(@"csBalance")]);
        KExcuteBlock(success, nil);
    } failure:^{
        KExcuteBlock(failure, nil);
    }];
}

/**
 *  更新投资账户的显示数据
 *
 *  @param success 成功
 *  @param failure 失败
 */
- (void)updateInvestAccount:(SuccessBlock)success failure:(FailureBlock)failure
{
    @weakify(self)
    [GYHSAccountHttpTool getInvestBalanceDetailWithSuccess:^(id responsObject) {
        @strongify(self);

        self.accumulativeInvestCount = kSaftToNSString(responsObject[GYNetWorkDataKey][kLocalized(@"accumulativeInvestCount")]);

        //后面的三个数据
        self.totalDividend = kSaftToNSString(responsObject[GYNetWorkDataKey][kLocalized(@"totalDividend")]);

        self.normalDividend = kSaftToNSString(responsObject[GYNetWorkDataKey][kLocalized(@"normalDividend")]);

        self.directionalDividend = kSaftToNSString(responsObject[GYNetWorkDataKey][kLocalized(@"directionalDividend")]);
        self.dividendYear = kSaftToNSString(responsObject[GYNetWorkDataKey][kLocalized(@"dividendYear")]);
        self.yearDividendRate = kSaftToNSString(responsObject[GYNetWorkDataKey][kLocalized(@"yearDividendRate")]);
        KExcuteBlock(success, nil);
    } failure:^{
        KExcuteBlock(failure, nil);
    }];
}

@end
