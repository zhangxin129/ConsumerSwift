//
//  GYHESCOrderModel.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JSONModel/JSONModel.h>
#import "GYHESCCartListModel.h"

@interface GYHESCOrderModel : JSONModel

@property (nonatomic, copy) NSString* vShopName; //商城名
@property (nonatomic, copy) NSString* vShopId; //商城ID

@property (nonatomic, strong) NSMutableArray* modelArray; //GYHESCCartListModel数组

@property (nonatomic, copy) NSString* totalNumber; //总数量
@property (nonatomic, copy) NSString* totalMoney; //总金钱
@property (nonatomic, copy) NSString* totalPv; //总积分
@property (nonatomic, copy) NSString* shopName; //营业点名
@property (nonatomic, copy) NSString* shopId; //营业点id
@property (nonatomic, copy) NSString* sendWay; //配送方式
@property (nonatomic, copy) NSString* deliveryType; //配送类型
@property (nonatomic, assign) CGFloat coinIconWidth; //金币图标宽度
@property (nonatomic, copy) NSString* sendMoney; //配送费
@property (nonatomic, copy) NSString* payOffWay; //支付方式
@property (nonatomic, copy) NSString* leaveMessage; //卖家留言
@property (nonatomic, assign) BOOL enableApplyCard; //能否申请互生卡
@property (nonatomic, assign) BOOL isApplyCard; //是否申请互生卡
@property (nonatomic, assign) BOOL isInvoice; //是否开具发票
@property (nonatomic, copy) NSString* invoiceHead; //发票抬头
@property (nonatomic, copy) NSString* couponId; //消费券id
@property (nonatomic, copy) NSString* amount; //消费券单价
@property (nonatomic, copy) NSString* num; //消费券数量
@property (nonatomic, copy) NSString *couponName;//消费券名
@property (nonatomic, assign) BOOL isUseConsume;//是否使用消费券

@property (nonatomic, copy) NSString *actuallyAmount;//实际消费金额

@end
