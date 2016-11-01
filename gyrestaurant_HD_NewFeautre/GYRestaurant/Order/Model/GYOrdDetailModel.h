//
//  GYOrdDetailModel.h
//  GYRestaurant
//
//  Created by ios007 on 15/10/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYCouponInfoModel.h"

@interface GYOrdDetailModel : NSObject

//订单Id
@property (nonatomic, copy) NSString *orderId;
//手机号
@property (nonatomic ,copy) NSString *orderPhone;
//互生号
@property (nonatomic, copy) NSString *resNo;
//联系地址
@property (nonatomic, copy) NSString *contactAddress;
//联系人
@property (nonatomic, copy) NSString *contactPerson;
//联系电话
@property (nonatomic, copy) NSString *contactPhone;
//送达时间
@property (nonatomic, copy) NSString *arriveTime;
//配送费
@property (nonatomic, copy) NSString *deliverFee;
//订单状态
@property (nonatomic, copy) NSString *orderStatus;
//付款状态
@property (nonatomic, copy) NSString *payStatus;
//下单时间
@property (nonatomic, copy) NSString *orderStartTime;
//订单金额
@property (nonatomic, copy) NSString *totalAmount;
//订单积分
@property (nonatomic, copy) NSString *totalPv;
//订单类型
@property (nonatomic, copy) NSString *orderType;
//结账数据
@property (nonatomic, copy) NSString *payedTime;
//订单备注
@property (nonatomic, copy) NSString *orderRemark;
//用餐人数
@property (nonatomic, copy) NSString *tableNum;
//预定就餐时间
@property (nonatomic, copy) NSString *mealTime;
//预付金额
@property (nonatomic, copy) NSString *prePayAmount;
//菜品总数量
@property (nonatomic, copy) NSString *totalFoodNum;
//菜品列表
@property (nonatomic, strong) NSMutableArray *foodList;
//开台号
@property (nonatomic, copy) NSString *tableNo;
//配送优惠
@property (nonatomic, copy) NSString *deliDiscount;
//总额
@property (nonatomic, copy) NSString *amountActually;
//预定就餐人数
@property (nonatomic, copy) NSString *personNum;
//后台统计的打单次数
@property (nonatomic, copy) NSString *sendOrderTime;
/**其他服务内容*/
@property (nonatomic, copy)NSString *amountOtherMsg;
/**其他服务金额*/
@property (nonatomic, copy)NSString *amountOther;
/**定金是否支付 0. 退还 1. 支付*/
@property (nonatomic, copy)NSString *checkOutType;
/**折扣方式*/
@property (nonatomic, copy)NSString *discountType;
/**折扣率*/
@property (nonatomic, copy)NSString *discountRate;
/**互生抵扣券张数面值id name*/
//@property (nonatomic, strong)GYCouponInfoModel *couponInfo;
@property (nonatomic, copy)NSString *couponInfo;
@end
