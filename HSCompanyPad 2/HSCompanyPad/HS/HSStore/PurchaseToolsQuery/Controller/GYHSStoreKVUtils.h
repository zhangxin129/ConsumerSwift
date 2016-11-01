//
//  GYHSStoreKVUtils.h
//  HSCompanyPad
//
//  Created by cook on 16/9/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>


#define GYHS_ToolPuash @"109"
#define GYHS_ApplyPersonResource @"110"
#define GYHS_SpecailCardFee @"107"
#define GYHS_HSRebuyCard @"106"
#define GYHS_PraviteFillCard @"104"
#define GYHS_AddNewTool @"103"
#define GYHS_PaySystemUseFee @"100"
#define GYHS_ResourceFee @"101"





@class GYHSStoreQueryDetailModel,GYHSStoreQueryListModel,GYHSMyPayYearFeeModel;
@interface GYHSStoreKVUtils : NSObject
/**
 *获取订单状态
 */
+ (NSString *)getOrderStatusWithStatus:(NSString *)status;
/**
 *获取订单支付方式
 */
+ (NSString *)getOrderPayWay:(NSString *)payWay;
/**
 *获取订订单类型
 */
+ (NSString *)getOrderType:(NSString *)orderType;
/**
 *获取订单渠道来源
 */
+ (NSString *)getOrderChannel:(NSString *)orderChannel;
/**
 *  获取支付状态
 *
 *  @param paystate <#paystate description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getPayState:(NSString *)paystate;
/**
 *获取详情的标题
 */
+ (NSArray *)getTitleListWithModel:(GYHSStoreQueryDetailModel *)model;
/**
 *获取详情的value
 */
+ (NSArray *)getValueListWithModel:(GYHSStoreQueryDetailModel *)model listModel:(GYHSStoreQueryListModel *)listModel yearFeeModel:(GYHSMyPayYearFeeModel *)yearFeeModel;

@end
