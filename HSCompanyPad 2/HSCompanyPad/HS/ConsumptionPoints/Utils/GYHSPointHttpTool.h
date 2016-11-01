//
//  GYHSPointTool.h
//  HSCompanyPad
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSPointHttpTool : NSObject
/**
 *  获取交易流水号
 *
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)getSourceTransNoWithsuccess:(HTTPSuccess)success failure:(HTTPFailure)failure;
/**
 *  查询平台设置的抵扣券使用配置参数
 *
 *  @param success 成功
 *  @param err     失败
 */
+ (void)custGloabalCouponWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)err;
//消费积分
+ (void)newPointWithSourceTransNo:(NSString*)sourceTransNo sourceTransAmount:(NSString*)sourceTransAmount pointSum:(NSString*)pointSum transType:(NSString*)type transAmount:(NSString*)transAmount orderAmount:(NSString *)orderAmount deductionVoucher:(NSString *)number perResNo:(NSString*)perResNo equipmentNo:(NSString*)equipmentNo equipmentType:(NSString*)equipmentType sourceBatchNo:(NSString*)sourceBatchNo pointRate:(NSString*)pointRate termRunCode:(NSString*)termRunCode secretCode:(NSString*)secretCode transPwd:(NSString*)pwd  success:(HTTPSuccess)success failure:(HTTPFailure)err;
//冲正
+ (void)correctWithTransType:(NSString*)transType transNo:(NSString*)transNo returnReason:(NSString*)reason equitpmentType:(NSString*)equitpmentType initiate:(NSString*)initiate termRunCode:(NSString*)termRunCode perResNo:(NSString*)perResNo equipmentNo:(NSString*)equipmentNo secretCode:(NSString*)secretCode sourceBatchNo:(NSString*)batchNo success:(HTTPSuccess)success failure:(HTTPFailure)err;
//查询二维码支付结果
+ (void)checkScanPayWithTermRunCode:(NSString *)termRunCode batchNo:(NSString *)batchNo equipmentNo:(NSString *)equipmentNo entCustId:(NSString *)entCustId entResNo:(NSString *)entResNo sourcePosDate:(NSString *)sourcePosDate success:(HTTPSuccess)success failure:(HTTPFailure)err;
//积分流水查询
+ (void)pointQueryWithEntResNo:(NSString *)entResNo perResNo:(NSString *)perResNo startDate:(NSString *)startDate endDate:(NSString *)endDate queryType:(NSString *)queryType curPage:(NSString *)curPage pageSize:(NSString *)pageSize success:(HTTPSuccess)success failure:(HTTPFailure)err;
//互生币预付定金
+ (void)prePointWithSourceTransNo:(NSString*)sourceTransNo transType:(NSString*)type sourceTransAmount:(NSString*)sourceTransAmount transAmount:(NSString *)transAmount perResNo:(NSString*)perResNo channelType:(NSString *)channelType equipmentNo:(NSString*)equipmentNo equipmentType:(NSString*)equipmentType sourceBatchNo:(NSString*)sourceBatchNo termRunCode:(NSString*)termRunCode secretCode:(NSString*)secretCode transPwd:(NSString*)pwd success:(HTTPSuccess)success failure:(HTTPFailure)err;
//预付定金撤销，结算查询
+ (void)searchPosEarnestWithperResNo:(NSString*)perNo curPage:(NSString*)curPage pageSize:(NSString*)size startDate:(NSString*)startDate success:(HTTPSuccess)success failure:(HTTPFailure)err;
//预付定金撤销、消费积分撤单
+ (void)cancelEarnestWithOldTransNo:(NSString*)oldTransNo sourceTransNo:(NSString*)sourceTransNo sourceTransDt:(NSString *)sourceTransDt termRunCode:(NSString*)termRunCode ecretCode:(NSString*)secretCode transPwd:(NSString*)pwd transType:(NSString*)transType perResNo:(NSString*)perResNo equipmentNo:(NSString*)equipmentNo sourceBatchNo:(NSString*)sourceBatchNo frag:(NSString*)frag success:(HTTPSuccess)success failure:(HTTPFailure)err;
//积分流水查询(可以撤单和退货的记录)
+ (void)checkPointWithEntCustId:(NSString *)entCustId hsResNo:(NSString *)hsResNo startDate:(NSString *)startDate businessType:(NSString *)businessType curPage:(NSString *)curPage pageSize:(NSString *)pageSize success:(HTTPSuccess)success failure:(HTTPFailure)err;
//预付定金结算
+ (void)earnestSettleWithTransType:(NSString*)transType pointSum:(NSString*)pointSum perResNO:(NSString*)perResNo sourceTransAmount:(NSString*)sourceTransAmount equipmentNo:(NSString*)equipmentNo equipmentType:(NSString*)equipmentType sourceBatchNo:(NSString*)sourceBatchNo transAmount:(NSString*)transAmount pointRate:(NSString*)pointRate termRunCode:(NSString*)termRunCode oldSourceTransNo:(NSString*)oldSourceTransNo sourceTransNo:(NSString*)sourceTransNo orderAmount:(NSString*)orderAmount deductionVoucher:(NSString*)deductionVoucher  success:(HTTPSuccess)success failure:(HTTPFailure)err;
//退货
+ (void)returnGoodsWithOldTransNo:(NSString*)oldTransNo sourceTransNo:(NSString*)sourceTransNo sourceTransAmount:(NSString*)sourceTransAmount transAmount:(NSString*)transAmount termRunCode:(NSString*)termRunCode equipmentNo:(NSString*)equipmentNo secretCode:(NSString*)secretCode transPwd:(NSString*)pwd transType:(NSString*)transType perResNo:(NSString*)perResNo strBatchNo:(NSString*)strBatchNo success:(HTTPSuccess)success failure:(HTTPFailure)failure;
@end
