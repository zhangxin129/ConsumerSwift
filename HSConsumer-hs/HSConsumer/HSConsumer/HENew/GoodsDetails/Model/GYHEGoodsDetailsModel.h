//
//  GYHEGoodsDetailsModel.h
//  HSConsumer
//
//  Created by lizp on 2016/10/24.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class SupportServiceModel;


@protocol SkuModel
@end
@interface GYHEGoodsDetailsModel : JSONModel

@property (nonatomic,strong) NSAttributedString *nameStr;

@property (nonatomic,copy) NSString <Optional>*idString;
@property (nonatomic,strong) NSArray <Optional>*props;
@property (nonatomic,copy) NSString <Optional>*picWordDetails;
@property (nonatomic,copy) NSString <Optional>*pv;//" : 10,
@property (nonatomic,strong) NSArray <Optional>*coupon;
@property (nonatomic,assign) BOOL isFreePostage;//是否包邮
//"coupon" : [
//            {
//                "amount" : 100,
//                "faceValue" : 10,
//                "id" : "3038414168327168",
//                "num" : 3
//            }
//            ],

@property (nonatomic,copy) NSString <Optional>*price;//" : 100,
@property (nonatomic,copy) NSString <Optional>*vshopName;//" : "互生-商铺名称",
@property (nonatomic,copy) NSString <Optional>*itemPreviewUrl;//" : null,
@property (nonatomic,strong) NSArray <SkuModel>*skus;
@property (nonatomic,strong) SupportServiceModel <Optional>*supportService;//支持服务  商品详情后的图片显示
@property (nonatomic,copy) NSString <Optional>*postage;//" : 10,
@property (nonatomic,copy) NSString <Optional>*vshopId;//" : "2817073842619392",
@property (nonatomic,copy) NSString <Optional>*name;//" : "测试10-11-18",
@property (nonatomic,strong) NSArray <Optional>*pics;//
//"pics" : [
//          {
//              "p700x700" : "",
//              "p200x200" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1tzWTB5WT1RXrhCrK.jpg",
//              "p110x110" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1PzWTByZT1RXrhCrK.jpg",
//              "sourceSize" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1PFWTByLT1RXrhCrK.jpg",
//              "p300x300" : "",
//              "p340x340" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1PXWTBybT1RXrhCrK.jpg",
//              "p400x400" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1tXWTBmhT1RXrhCrK.jpg"
//          }
//          ]



@end

//支持的服务
@interface SupportServiceModel : JSONModel

@property (nonatomic,assign) BOOL hasSerDeposit;
@property (nonatomic,assign) BOOL hasSerTakeout;
@property (nonatomic,assign) BOOL hasSerCoupon;

@end



//商品的sku集合
@protocol SkuNameModel
@end
@interface SkuModel : JSONModel

@property (nonatomic,copy) NSString <Optional>*pv;
@property (nonatomic,copy) NSString <Optional>*idString;//id
@property (nonatomic,copy) NSString <Optional>*price;
@property (nonatomic,strong) NSArray <SkuNameModel>*sku;
@property (nonatomic,copy) NSString <Optional>*skuTfsFileName;
@property (nonatomic,copy) NSString <Optional>*stock;
@property (nonatomic,strong) NSDictionary <Optional>*sukPicSize;
//    "sukPicSize" : {
//        "p700x700" : "",
//        "p200x200" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1nzWTBCLT1RXrhCrK.jpg",
//        "p110x110" : "",
//        "sourceSize" : "",
//        "p300x300" : "",
//        "p340x340" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1lzWTByDT1RXrhCrK.jpg",
//        "p400x400" : "http:\/\/192.168.229.31:9099\/v1\/tfs\/T1nFWTB5JT1RXrhCrK.jpg"
//    }


@end


//具体某个商品的属性
@interface SkuNameModel : JSONModel

@property (nonatomic,copy) NSString <Optional>*pId;
@property (nonatomic,copy) NSString <Optional>*pName;
@property (nonatomic,copy) NSString <Optional>*pVId;
@property (nonatomic,copy) NSString <Optional>*isColor;
@property (nonatomic,copy) NSString <Optional>*pVName;

@end




