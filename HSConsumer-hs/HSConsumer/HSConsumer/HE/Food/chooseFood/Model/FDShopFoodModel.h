//
//  FDShopFoodCategoryModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "JSONModel+LoadData.h"
#import "FDFoodCategoryModel.h"

@interface FDShopFoodModel : JSONModel
@property (strong, nonatomic) NSArray<FDFoodCategoryModel>* categoryList;
@property (copy, nonatomic) NSString* fullOffDesc;
@property (copy, nonatomic) NSString* hsNo;
@property (copy, nonatomic) NSString* moneyEarnest;
@property (copy, nonatomic) NSString* openingHours;
@property (copy, nonatomic) NSString* sendPrice;
@property (copy, nonatomic) NSString* sendPriceMin;
@property (copy, nonatomic) NSString* shopAddr;
@property (copy, nonatomic) NSString* shopEvgPrice;
@property (copy, nonatomic) NSString* shopId;
@property (copy, nonatomic) NSString* shopLandMark;
@property (copy, nonatomic) NSString* shopName;
@property (copy, nonatomic) NSString* shopPic;
@property (copy, nonatomic) NSString* shopPoint;
@property (copy, nonatomic) NSString* shopTip;
@property (copy, nonatomic) NSString* tel;
@property (copy, nonatomic) NSString* vShopId;
@property (copy, nonatomic) NSString* tfsDomain;
@property (strong, nonatomic) NSArray* timeresultShop2;
@property (strong, nonatomic) NSArray* timeresultSince2;
@property (strong, nonatomic) NSArray* timeresultTakeaway;
@property (strong, nonatomic) NSArray* timeresultShopNoOpen;
@property (strong, nonatomic) NSArray* timeresultSinceNoOpen;
@property (copy, nonatomic) NSDictionary* itemSale;
@property (copy, nonatomic) NSString* fullPrice;
@property (copy, nonatomic) NSString* offPrice;
@property (copy, nonatomic) NSString* supportService;
@property (strong, nonatomic) NSDictionary* supportServiceDict;
@property (copy, nonatomic) NSString* sendRange;
@property (nonatomic, copy) NSString* dikou;
@property (nonatomic, copy) NSString* qiSongPrice;
@property (nonatomic, copy) NSString* orderHours;
@end
