//
//  GYOrderModel.h
//  HSConsumer
//
//  Created by appleliss on 15/9/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
@class GYOrderModel;
typedef void (^GYOderModelDataBlock)(NSMutableDictionary* dic, NSError* error);
typedef void (^retCodeBlock)(NSString* retCode, NSError* error);

#import "MJExtension.h"
#import "JSONModel.h"
#import "FDFoodModel.h"

@interface GYOrderModel : NSObject

@property (nonatomic, copy) NSString* userKey; ////用户的key
@property (nonatomic, copy) NSString* userIds; ////
@property (nonatomic, copy) NSString* type; ////订单类型，1 店内，2外卖,3 自提
@property (nonatomic, copy) NSString* shopId; ////营业点ID
@property (nonatomic, copy) NSString* vShopId; ////企业ID
@property (nonatomic, copy) NSString* totalAmount; ////菜品总金额
@property (nonatomic, copy) NSString* totalPv; ////菜品积分

@property (nonatomic, copy) NSString* payment; ////支付方式
@property (nonatomic, copy) NSString* useDate; ////配送时间/用餐时间
@property (nonatomic, copy) NSString* remark; ////备注
@property (nonatomic, copy) NSString* isBill; ////是否需要发票
@property (nonatomic, copy) NSString* isCoupon; ////使用消费抵扣劵
@property (nonatomic, copy) NSString* contactor; ////联系人
@property (nonatomic, copy) NSString* receiverAddr; ////  地址
@property (nonatomic, copy) NSString* tel; ////联系电话
@property (nonatomic, copy) NSString* preAmount; /////预付金额 prePayAmount
@property (nonatomic, copy) NSString* amountActually; /////应付金额  实付金额
@property (nonatomic, copy) NSString* personNum; ////用餐人数
@property (nonatomic, copy) NSString* createTime;//下单时间

@property (nonatomic, copy) NSMutableArray* foodArr; ///菜品列表

@property (nonatomic, strong) FDFoodModel* foodModel; ////菜品模型
@property (nonatomic, copy) NSString* shopTel; ///餐厅电话
@property (nonatomic, copy) NSString* restaurantAddres; ///餐厅地址
@property (nonatomic, copy) NSString* restaurantName; ////餐厅名称
@property (nonatomic, copy) NSString* companyResourceNo; ////企业的互生号
@property (nonatomic, copy) NSString* orderSate; ////订单状态
@property (nonatomic, copy) NSString* orderNumber; ////订单号
@property (nonatomic, copy) NSString* orderTime; /////下单时间
@property (nonatomic, copy) NSString* hsNumber; ///互生号
@property (nonatomic, copy) NSString* totalPy; ////订单积分
@property (nonatomic, copy) NSString* takeCode; //////自提码
@property (nonatomic, copy) NSString* remarkStatus; //////评价标示
@property (nonatomic, copy) NSString* amountOther; //其他费用
@property (nonatomic, copy) NSString* amountOtherMsg; //其他服务内容
@property (nonatomic, copy) NSString* discountType; //折扣类型
@property (nonatomic, copy) NSString* discountRate; //折扣率
@property (nonatomic, copy) NSString* discountAmount; //折扣金额
@property (nonatomic, copy) NSString* amountCoupon; //抵扣金额
@property (nonatomic, copy) NSString* couponInfo; //抵扣劵信息
@property (nonatomic, copy) NSString* sendPrice; //配送费
@property (nonatomic, copy) NSString* amountLogistic; //配送费 详情里面的
@property (nonatomic, copy) NSString* deliDiscount; ///餐厅活动详情
/*
 *   确认订单
 */
+ (void)confirmanOrderFromNetWork:(NSData*)params andUrl:(NSString*)url andOrdeBlock:(retCodeBlock)block;

/*
 *   订单列表
 */
+ (void)orderDataFromNetWork:(NSDictionary*)params andUrl:(NSString*)url andOrdeBlock:(GYOderModelDataBlock)block;
/**
 *
 *订单详情
 *
 **/
+ (void)requestOrderDetailsforNetWork:(NSDictionary*)params andUrl:(NSString*)url andOrderDetails:(GYOderModelDataBlock)block;

/***
 *取消订单
 */
+ (void)cancelOrderFromNetWork:(NSDictionary *)params andUrl:(NSString *)url andOrderBlock:(GYOderModelDataBlock)block;

/*
 *企业给消费者下单  消费者确认
 *
 */
+ (void)enterpriseToConsumersPlaceOrder:(NSDictionary *)params andUrl:(NSString *)url andRetCodeBlock:(GYOderModelDataBlock)block;

/*
 *外卖  消费者确认收货
 *
 */
+ (void)confirmGoods:(NSDictionary *)params andUrl:(NSString *)url andRetCodeBlock:(GYOderModelDataBlock)block;


@end
