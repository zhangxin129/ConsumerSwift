//
//  GYHSStoreQueryDetailModel.h
//  HSCompanyPad
//
//  Created by cook on 16/9/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYHSStoreDeliverInfoModel,GYHSToolAfterDetail;
@class GYHSStoreOrderInfoModel;
@class GYHSStoreConfsModel;

@interface GYHSStoreQueryDetailModel : NSObject
@property (nonatomic, strong) NSArray *confsInfo;
@property (nonatomic, strong) GYHSStoreDeliverInfoModel *deliverInfo;//只有申购付款发货的这个才会有值
@property (nonatomic, strong) GYHSStoreOrderInfoModel *orderInfo;
@property (nonatomic, strong) NSArray *afterDetail;//只有售后工具维修费才会有这个集合
@end

@interface GYHSStoreToolAfterDetailModel : NSObject
@property (nonatomic, copy) NSString *deviceSeqNo;
@property (nonatomic, copy) NSString *disposeStatus;
@end

@interface GYHSStoreDeliverInfoModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *linkman;
@property (nonatomic, copy) NSString *phone;
@end

@interface GYHSStoreConfsModel : NSObject
@property (nonatomic, copy) NSString *cardStyleId;//卡样id
@property (nonatomic, copy) NSString *categoryCode;//
@property (nonatomic, copy) NSString *confDate;
@property (nonatomic, copy) NSString *confNo;
@property (nonatomic, copy) NSString *confStatus;
@property (nonatomic, copy) NSString *confType;
@property (nonatomic, copy) NSString *confUser;
@property (nonatomic, copy) NSString *sss;
@property (nonatomic, copy) NSString *hsCustId;
@property (nonatomic, copy) NSString *hsResNo;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *shippingId;
@property (nonatomic, copy) NSString *storeOutNo;
@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *whId;
@property (nonatomic, copy) NSString *productPic;

@end


@interface GYHSStoreOrderInfoModel : NSObject
@property (nonatomic, copy) NSString *orderChanel;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *orderOperator;
@property (nonatomic, copy) NSString *orderPayChanel;
@property (nonatomic, copy) NSString *orderRemark;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *orderAmount;
@end