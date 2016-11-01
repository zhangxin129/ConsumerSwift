//
//  GYPayoffModel.h
//  HSConsumer
//
//  Created by 00 on 15-2-9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddrModel : NSObject

@property (copy, nonatomic) NSString* area;
@property (copy, nonatomic) NSString* beDefault;
@property (copy, nonatomic) NSString* city;
@property (copy, nonatomic) NSString* consignee;
@property (copy, nonatomic) NSString* detail;
@property (copy, nonatomic) NSString* addrID;
@property (copy, nonatomic) NSString* mobile;
@property (copy, nonatomic) NSString* province;
@property (copy, nonatomic) NSString* PostCode;

//@property (copy ,nonatomic) NSString *receiver;

@end

@interface GoodsListModel : NSObject

@property (copy, nonatomic) NSString* categoryId;
@property (copy, nonatomic) NSString* itemId;
@property (copy, nonatomic) NSString* itemName;
@property (copy, nonatomic) NSString* point;
@property (copy, nonatomic) NSString* price;
@property (copy, nonatomic) NSString* quantity;
@property (copy, nonatomic) NSString* skuId;
@property (copy, nonatomic) NSString* subPoints;
@property (copy, nonatomic) NSString* subTotal;
@property (copy, nonatomic) NSString* vShopId;

@end

@interface GYPayoffModel : NSObject

@property (copy, nonatomic) NSString* actuallyAmount;
@property (copy, nonatomic) NSString* channelType;
@property (copy, nonatomic) NSString* companyResourceNo;
@property (copy, nonatomic) NSString* deliveryType;
@property (copy, nonatomic) NSString* invoiceTitle;
@property (copy, nonatomic) NSString* isDrawed;
@property (copy, nonatomic) NSString* isPayOnDelivery;
@property (copy, nonatomic) NSString* orderDetailList;
@property (strong, nonatomic) NSMutableArray* goodsList;

@property (copy, nonatomic) NSString* postAge;
@property (copy, nonatomic) NSString* receiver;
@property (copy, nonatomic) NSString* receiverAddress;
@property (copy, nonatomic) NSString* receiverContact;
@property (copy, nonatomic) NSString* receiverPostCode;
@property (copy, nonatomic) NSString* serviceResourceNo;
@property (copy, nonatomic) NSString* shopId;
@property (copy, nonatomic) NSString* shopName;
@property (copy, nonatomic) NSString* totalAmount;
@property (copy, nonatomic) NSString* totalPoints;
@property (copy, nonatomic) NSString* userNote;
@property (copy, nonatomic) NSString* vShopId;
@property (copy, nonatomic) NSString* vShopName;

@end
