//
//  GYHSTakeAwayDetailAllModel.h
//  HSConsumer
//
//  Created by kuser on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GYHSTakeAwayOrderDetailsCellModel
@end

@interface GYHSTakeAwayOrderDetailsCellModel : JSONModel

@property (nonatomic, copy) NSString* count; //数量
@property (nonatomic, copy) NSString* pv; //积分
@property (nonatomic, copy) NSString* price; //价格
@property (nonatomic, copy) NSString* title; //商品名称

@end

@interface GYHSTakeAwayDetailAllModel : JSONModel

@property (nonatomic, copy) NSString* confirmTime; //确认送达时间
@property (nonatomic, copy) NSString* arriveTime; //送达时间
@property (nonatomic, copy) NSString* cutMoney; //抵扣卷
@property (nonatomic, copy) NSString* payTime; //支付时间
@property (nonatomic, copy) NSString* reallyPay; //实付
@property (nonatomic, copy) NSString* receiveTime; //接单时间
@property (nonatomic, copy) NSString* receiver; //联系人
@property (nonatomic, copy) NSString* receiverAddress; //收餐地址
@property (nonatomic, copy) NSString* receiverContact; //联系电话
@property (nonatomic, copy) NSString* sendTime; //期望送达时间
@property (nonatomic, copy) NSString* shopName; //商店名字
@property (nonatomic, copy) NSString* status; //订单状态
@property (nonatomic, copy) NSString* totalCut; //总共商品
@property (nonatomic, copy) NSString* totalPrice; //合计金额
@property (nonatomic, copy) NSString* totalPV; //合计积分
@property (nonatomic, copy) NSString *postPrice;//运费

@property (nonatomic, strong) NSArray<GYHSTakeAwayOrderDetailsCellModel> *items;

@end
