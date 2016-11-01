//
//  GYEasyBuyModel.m
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasyBuyModel.h"
#import "MJExtension.h"
//商品模型
@implementation GYEasyBuyModel

+ (GYEasyBuyModel*)initWithName:(NSString*)name pictureURL:(NSString*)picture
{
    GYEasyBuyModel* eb = [[self alloc] init];
    eb.strGoodName = name;
    eb.strGoodPictureURL = picture;
    return eb;
}

+ (GYEasyBuyModel*)initWithName:(NSString*)name price:(NSString*)price_ pictureURL:(NSString*)picture
{
    GYEasyBuyModel* eb = [[self alloc] init];
    eb.strGoodName = name;
    eb.strGoodPrice = price_;
    eb.strGoodPictureURL = picture;
    return eb;
}

@end

//商铺模型
@implementation ShopModel

MJCodingImplementation
    + (ShopModel*)initWithName : (NSString*)name address : (NSString*)pAddress tel : (NSString*)pTel pictureURL : (NSString*)picture
{
    ShopModel* shop = [[ShopModel alloc] init];
    shop.strShopName = name;
    shop.strShopAddress = pAddress;
    shop.strShopTel = pTel;
    shop.strShopPictureURL = picture;
    return shop;
}

+ (ShopModel*)modelWithDictionary:(NSDictionary*)dict
{

    ShopModel* model = [[ShopModel alloc] init];

    model.strShopId = kSaftToNSString(dict[@"shopid"]);
    model.strVshopId = kSaftToNSString(dict[@"vShopId"]);
    model.strShopAddress = kSaftToNSString(dict[@"addr"]);
    model.strShopTel = kSaftToNSString(dict[@"tel"]);
    model.strShopPictureURL = kSaftToNSString(dict[@"shopPic"]);
    model.strCompanyName = kSaftToNSString(dict[@"companyName"]);
    model.beCash = kSaftToNSString(dict[@"beCash"]);
    model.beReach = kSaftToNSString(dict[@"beReach"]);
    model.beSell = kSaftToNSString(dict[@"beSell"]);
    model.beTake = kSaftToNSString(dict[@"beTake"]);
    model.beQuan = kSaftToNSString(dict[@"beQuan"]);
    model.categoryNames = kSaftToNSString(dict[@"categoryNames"]);
    model.shopDistance = kSaftToNSString(dict[@"dist"]);

    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.marrAllShop = [NSMutableArray array];
        self.marrHotGoods = [NSMutableArray array];
        self.marrShopImages = [NSMutableArray array];
    }
    return self;
}



@end