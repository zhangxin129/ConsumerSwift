//
//  GYShopBaseInfoModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYShopBaseInfoModel : NSObject
@property (nonatomic, copy) NSString* addr;
@property (nonatomic, copy) NSString* area;
@property (nonatomic, assign) BOOL bePre;
@property (nonatomic, assign) BOOL beFocus;
@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* companyResourceNo;
@property (nonatomic, copy) NSString* evacount;
@property (nonatomic, copy) NSString* hotline;
@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* introduce;
@property (nonatomic, copy) NSString* lat;
@property (nonatomic, copy) NSString* longitude;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* province;
@property (nonatomic, copy) NSString* rating;
@property (nonatomic, copy) NSString* vShopId;

@property (nonatomic, copy) NSString* vShopName;
@property (nonatomic, copy) NSString* vShopUrl;

@property (nonatomic, strong) NSArray* images;
@property (nonatomic, strong) NSArray* picList;
@property (nonatomic, strong) NSArray* shops;
@end

@interface GYShopBaseInfoPicListModel : NSObject
@property (nonatomic, copy) NSString* url;
@end

@interface GYShopBaseInfoImagesModel : NSObject

@end

@interface GYShopBaseInfoShopsModel : NSObject
@property (nonatomic, copy) NSString* addr;
@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* longitude;
@property (nonatomic, copy) NSString* lat;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString *tel;
@end

