//
//  FDFoodDetailModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/11/3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
@protocol FDFoodDetailModel

@end

#import "JSONModel+LoadData.h"

@interface FDFoodDetailModel : JSONModel
@property (copy, nonatomic) NSString* categoryId;
@property (copy, nonatomic) NSString* categoryName;
@property (copy, nonatomic) NSString* companyName;
@property (copy, nonatomic) NSString* companyResourceNo;
@property (copy, nonatomic) NSString* createTime;
@property (copy, nonatomic) NSString* creator;
@property (copy, nonatomic) NSString* foodId;
@property (copy, nonatomic) NSString* introduce;
@property (copy, nonatomic) NSString* itemDetailInfo;
@property (copy, nonatomic) NSString* listShopIds;
@property (copy, nonatomic) NSString* lstItemStorage;
@property (copy, nonatomic) NSString* lstNotItemId;
@property (copy, nonatomic) NSString* modifier;
@property (copy, nonatomic) NSString* modifyTime;
@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* picList;
@property (copy, nonatomic) NSString* pics;
@property (copy, nonatomic) NSString* pingyingCode;
@property (copy, nonatomic) NSString* price;
@property (copy, nonatomic) NSString* priceRegion;
@property (copy, nonatomic) NSString* pv;
@property (copy, nonatomic) NSString* pvRate;
@property (copy, nonatomic) NSString* pvRegion;
@property (copy, nonatomic) NSString* serviceResourceNo;
@property (copy, nonatomic) NSString* shopCategoryId;
@property (copy, nonatomic) NSString* skuList;
@property (copy, nonatomic) NSString* standard;
@property (copy, nonatomic) NSString* status;
@property (copy, nonatomic) NSString* tag;
@property (copy, nonatomic) NSString* taste;
@property (copy, nonatomic) NSString* virtualShopId;
@property (strong, nonatomic) NSArray* foodFormat;
@property (copy, nonatomic) NSString* foodPicParsed;
@property (copy, nonatomic) NSNumber *saleNum;


@end
