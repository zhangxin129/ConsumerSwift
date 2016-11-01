//
//  GYHSStoreQueryListModel.h
//  HSCompanyPad
//
//  Created by cook on 16/9/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSStoreQueryListModel : NSObject
@property (nonatomic, copy) NSString *bizNo;//原业务编号
@property (nonatomic, copy) NSString *currencyCode;//订单货币币种
@property (nonatomic, copy) NSString *custId;//客户号
@property (nonatomic, copy) NSString *custName;//客户名称
@property (nonatomic, copy) NSString *custType;//客户类型 2:成员 3:托管
@property (nonatomic, copy) NSString *deliverId;//收货信息编号
@property (nonatomic, copy) NSString *deliverInfoBean;
@property (nonatomic, copy) NSString *exchangeRate;//货币转换比率
@property (nonatomic, copy) NSString *hsResNo;//互生号
@property (nonatomic, copy) NSString *isInvoiced;//是否已开发票
@property (nonatomic, copy) NSString *isNeedInvoice;//是否需要发票
@property (nonatomic, copy) NSString *isProxy;//是否平台代理
@property (nonatomic, copy) NSString *orderCashAmount;//折合货币金额
@property (nonatomic, copy) NSString *orderChannel;//订单渠道来源(受理方式)
//  订单渠道来源
//  1:网页接入
//  2:POS接入
//  3:刷卡器接入
//  4:移动App接入
//  5:互生平板接入
//  6:互生系统接入
//  7:语音接入
//  8:第三方接入
@property (nonatomic, copy) NSString *orderDerateAmount;//订单减免金额
@property (nonatomic, copy) NSString *orderHsbAmount;//折合互生币金额
@property (nonatomic, copy) NSString *orderNo;//订单编号
@property (nonatomic, copy) NSString *orderOperator;//订单操作员
@property (nonatomic, copy) NSString *orderOriginalAmount;//订单原始金额
@property (nonatomic, copy) NSString *orderRemark;//订单备注
@property (nonatomic, copy) NSString *orderStatus;//订单状态
//  订单状态
//  1：待付款
//  2：待配货
//  3：已完成
//  4：已过期
//  5：已关闭
//  6：待确认
//  7：已撤单
//  不填，BS默认
@property (nonatomic, copy) NSString *orderTime;//订单时间
@property (nonatomic, copy) NSString *orderType;//订单类型 103：申购工具 不填，BS默认
@property (nonatomic, copy) NSString *orderUnit;//订单单位
@property (nonatomic, assign) NSInteger payChannel;//支付方式
//  支付方式
//  100：网银支付
//  101:手机移动支付
//  102：快捷支付
//  200：互生币支付
//  300：货币支付
//  400：线下支付
@property (nonatomic, copy) NSString *payOvertime;//支付超时时间
@property (nonatomic, copy) NSString *payStatus;//支付状态
//  支付状态
//  0：待付款
//  1：处理中
//  2：已付款
//  3：付款失败
//  不填，BS默认
@property (nonatomic, copy) NSString *payTime;//支付时间
@property (nonatomic, copy) NSString *quantity;//订单数量
@property (nonatomic, copy) NSString *toolStatus;


@end
