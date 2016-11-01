//
//  GYHEShopDetailGoodListModel.h
//  HSConsumer
//
//  Created by xiongyn on 16/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GYHEShopDetailGoodCouponModel;

@protocol GYHEShopDetailGoodSkuModel;

@protocol GYHEShopDetailGoodSkuSonModel;


@interface GYHEShopDetailGoodCouponModel : JSONModel

@property (nonatomic, copy)NSString * amount;// 100,
@property (nonatomic, copy)NSString *faceValue;//10,
@property (nonatomic, copy)NSString *id;//"3038414168327168",
@property (nonatomic, copy)NSString *num;// 3
//amount = 100;
//faceValue = 10;
//id = 3038414168327168;
//num = 3;

@end

@interface GYHEShopDetailGoodSkuSonModel : JSONModel

@property (nonatomic, copy)NSString *isColor;// 1;
@property (nonatomic, copy)NSString *pId;// 2448717199852544;
@property (nonatomic, copy)NSString *pName;//"\U989c\U8272";
@property (nonatomic, copy)NSString *pVId;// 3067958004171778;
@property (nonatomic, copy)NSString *pVName;// cccc;

@end

@interface GYHEShopDetailGoodSkuModel : JSONModel

@property (nonatomic, copy)NSString *pv;// 6,
@property (nonatomic, copy)NSString *id;// "3069468720563201",
@property (nonatomic, copy)NSString *stock;// 7,
@property (nonatomic, copy)NSString *price;// 600,
@property (nonatomic, strong)NSArray<GYHEShopDetailGoodSkuSonModel> *sku;// null
//skuTfsFileName
//sukPicSize

@property (nonatomic, assign)NSInteger count;

@end

@interface GYHEShopDetailGoodListModel : JSONModel

@property (nonatomic, strong)NSArray<GYHEShopDetailGoodCouponModel> *coupon;
@property (nonatomic, strong)NSArray<GYHEShopDetailGoodSkuModel> *skus;
@property (nonatomic, strong)NSDictionary *supportService;//["6","3"]
@property (nonatomic, copy)NSString *city;//"深圳市",
@property (nonatomic, copy)NSString *pv;//10,
@property (nonatomic, copy)NSString *price;//100
@property (nonatomic, copy)NSString *addr;// null,
@property (nonatomic, copy)NSString *name;//"测试10-11-18"
@property (nonatomic, copy)NSString *isFreePostage;
@property (nonatomic, copy)NSString *postage;
@property (nonatomic, strong)NSArray *pics;
//{
//    "p200x200" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1tzWTB5WT1RXrhCrK.jpg",
//    "p300x300" : "",
//    "p110x110" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1PzWTByZT1RXrhCrK.jpg",
//    "p400x400" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1tXWTBmhT1RXrhCrK.jpg",
//    "sourceSize" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1PFWTByLT1RXrhCrK.jpg",
//    "p340x340" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1PXWTBybT1RXrhCrK.jpg"
//}

@end

