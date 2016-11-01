//
//  GYHESCPaymentModel.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GYHESCOrderDetailListModel

@end

@interface GYHESCOrderDetailListModel : JSONModel

@property (nonatomic, copy) NSString* quantity; //购买数量
@property (nonatomic, copy) NSString* categoryId; //商品类目ID
@property (nonatomic, copy) NSString* ruleId; //
@property (nonatomic, copy) NSString* vShopId; //商城ID
@property (nonatomic, copy) NSString* isApplyCard; //是否申请互生卡
@property (nonatomic, copy) NSString* itemName; //商品名称
@property (nonatomic, copy) NSString* skuId; //SKU ID
@property (nonatomic, copy) NSString* price; //单价
@property (nonatomic, copy) NSString* subTotal; //商品金额小计
@property (nonatomic, copy) NSString* point; //单个商品的积分
@property (nonatomic, copy) NSString* skus; //商品sku串，包括sku名称，sku值名称
@property (nonatomic, copy) NSString* shopId; //营业点ID
@property (nonatomic, copy) NSString* subPoints; //商品积分小计
@property (nonatomic, copy) NSString* itemId; //商品ID

@end

@interface GYHESCPaymentModel : JSONModel

@property (nonatomic, copy) NSString* userNote; //买家备注
@property (nonatomic, copy) NSString* companyResourceNo; //企业资源号
@property (nonatomic, copy) NSString* payType; //是否货到付款  0 否，1 是
@property (nonatomic, copy) NSString* sendWay; //配送方式
@property (nonatomic, copy) NSString* shopId; //营业点ID
@property (nonatomic, copy) NSString* shopName; //营业点名称
@property (nonatomic, strong) NSNumber* totalPoints; //消费积分
@property (nonatomic, copy) NSString* actuallyAmount; //实付金额(totalAmount  - couponAmount )
@property (nonatomic, copy) NSString* channelType; //订单来源 1 web,2 手机 3 平板
@property (nonatomic, copy) NSString* deliveryType; //1 快递 2 营业点自提 3 送货上门
@property (nonatomic, copy) NSString* vShopName; //商城名称
@property (nonatomic, copy) NSString* couponInfo; //使用抵扣券信息JSON格式，包括券ID，券名称，使用张数，面值{id:101,name:"元旦促销",num:5,faceValue:10}
@property (nonatomic, copy) NSString* isDrawed; //是否开具发票 0：默认不开具，1：开具
@property (nonatomic, copy) NSString* Express; //快递
@property (nonatomic, copy) NSString* serviceResourceNo; //服务公司资源号
@property (nonatomic, copy) NSString* receiverAddress; //收件人地址
@property (nonatomic, copy) NSString* receiverContact; //收货人联系电话
@property (nonatomic, copy) NSString* postAge; //快递运费
@property (nonatomic, copy) NSString* couponAmount; //抵扣券抵扣金额
@property (nonatomic, copy) NSString* receiver; //收件人
@property (nonatomic, strong) NSNumber* totalAmount; //总金额
@property (nonatomic, copy) NSString* invoiceTitle; //发票抬头
@property (nonatomic, copy) NSString* vShopId; //商城ID
@property (nonatomic, copy) NSString* receiverPostCode; //收件人邮编
@property (nonatomic, copy) NSString *coinCode;//币种代码

@property (nonatomic, strong) NSMutableArray<GYHESCOrderDetailListModel> *orderDetailList;//订单详情
@property (nonatomic, copy) NSString *DiscountDetail;//抵扣券信息
@property (nonatomic, copy) NSString *isSelectDiscount;//是否选择使用消费抵扣券
@property (nonatomic, copy) NSString *discount;//抵扣券信息
//@property (nonatomic, copy) NSString *buyerAccountNo;
@end
