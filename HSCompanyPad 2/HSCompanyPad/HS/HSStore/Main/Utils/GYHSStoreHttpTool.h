//
//  GYHSStoreHttpTool.h
//  HSCompanyPad
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSStoreHttpTool : NSObject

/**
 *  工具申购列表或互生卡申购
 */
+ (void)getApplyProgressToolType:(NSString*)toolType
                      success:(HTTPSuccess)success
                      failure:(HTTPFailure)failure;


/**
 *  查询工具可申购数量
 */
+ (void)getQueryMayBuyToolNumCategoryCode:(NSString*)categoryCode
                               success:(HTTPSuccess)success
                               failure:(HTTPFailure)failure;

/**
 *  收货地址列表
 */
+ (void)getReciveAddr:(HTTPSuccess)success
           failure:(HTTPFailure)failure;

/**
 *  删除收货地址
 */
+ (void)deleteAddressWithAddrId:(NSString *)addrId success:(HTTPSuccess) success failure :(HTTPFailure) failure;

/**
 *  添加收货地址
 */
+ (void)postAddAddressWithReceiver:(NSString*)receiver provinceNo:(NSString*)provinceNo cityNo:(NSString*)cityNo area:(NSString*)area address:(NSString*)adress postCode:(NSString*)postCode phone:(NSString*)phone mobile:(NSString*)mobile isDefault:(NSString*)isDefault success:(HTTPSuccess)success failure:(HTTPFailure)failure;
/**
 *  修改收货地址
 */
+ (void)updateAddressWithAddrId:(NSString*)addrId receiver:(NSString*)receiver provinceNo:(NSString*)provinceNo cityNo:(NSString*)cityNo area:(NSString*)area address:(NSString*)adress postCode:(NSString*)postCode phone:(NSString*)phone mobile:(NSString*)mobile isDefault:(NSString*)isDefault success:(HTTPSuccess)success failure:(HTTPFailure)failure;
/**
 *  查询企业资源段
 */
+ (void)getQueryEntResourceSegmentWithSuccess:(HTTPSuccess)success
                                   failure:(HTTPFailure)failure;

/**
 *  查询企业下的个性卡样列表
 */
+ (void)getListConfirmCardStyle:(HTTPSuccess)success
                     failure:(HTTPFailure)failure;


/**
 *  个性卡定制列表
 */
+ (void)getListSpecCardStylePageSize:(NSString*)pageSize
                          curPage:(NSString*)curPage
                          success:(HTTPSuccess)success
                          failure:(HTTPFailure)failure;
/**
 *  确认卡样
 */
+ (void)getConfirmCardStyleWithOrderNo:(NSString*)orderNo success:(HTTPSuccess)success failure:(HTTPFailure)failure;

/**
 *  个性卡定制 下单
 */
+ (void)submitCardStyleOrderCardStyleName:(NSString*)cardStyleName
                                remark:(NSString*)materialMicroPic
                    materialSourceFile:(NSString*)materialSourceFile
                               success:(HTTPSuccess)success
                               failure:(HTTPFailure)failure;
/**
 *  申购互生卡或工具 提交订单
 */
+ (void)submitToolBuyOrderToolList:(NSArray*)toolList
                              addr:(NSDictionary*)toolAddr
                         orderType:(NSString*)orderType
                    orderHsbAmount:(NSString*)orderHsbAmount
                           success:(HTTPSuccess)success
                           failure:(HTTPFailure)failure;

/**
 *  申购工具订单 立即支付(互生币支付)
 */
+ (void)HSBpayToolOrderOrderNo:(NSString*)orderNo
                 payChannel:(NSNumber*)payChannel
                   tradePwd:(NSString*)tradePwd
                    success:(HTTPSuccess)success
                    failure:(HTTPFailure)failure;
+ (void)queryAllOrderListOrderType:(NSString*)orderType
                          dateFlag:(NSString*)dateFlag
                           curPage:(NSString*)curPage
                          pageSize:(NSString*)pageSize
                           success:(HTTPSuccess)success
                           failure:(HTTPFailure)failure;
/**
 *  获取申购工具订单详情
 */
+ (void)getToolBuyOrderInfoOrderNo:(NSString*)orderNo
                           success:(HTTPSuccess)success
                           failure:(HTTPFailure)failure;
/**
 *  取消订单
 */
+ (void)cancelOrderByOrderNo:(NSString*)orderNo
                           success:(HTTPSuccess)success
                           failure:(HTTPFailure)failure;
@end
