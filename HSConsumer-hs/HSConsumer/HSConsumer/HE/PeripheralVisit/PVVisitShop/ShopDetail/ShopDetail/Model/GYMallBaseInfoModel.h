//
//  GYMallBaseInfoModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/9/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

typedef void (^dictResult)(NSDictionary* dictData, NSError* error, NSString* retCode);
#import <Foundation/Foundation.h>
@interface GYMallBaseInfoModel : NSObject
@property (nonatomic, assign) BOOL beFocus;
@property (nonatomic, copy) NSString* companyResourceNo;
@property (nonatomic, copy) NSString* introduce;
@property (nonatomic, copy) NSString* isApplyCard;
@property (nonatomic, copy) NSString* rate;
@property (nonatomic, copy) NSString* vShopName;
@property (nonatomic, copy) NSString* vShopUrl;
@property (nonatomic, strong) NSArray* picList;
@property (nonatomic, strong) NSArray* shops;

#pragma mark 加载商城详情
+ (void)loadBigShopDataWithVshopid:(NSString*)vShopID landMark:(NSString*)landMark result:(dictResult)result;
@end

@interface GYMallBaseInfoPicListModel : NSObject
@property (nonatomic, copy) NSString* url;
@end

@interface GYMallBaseInfoShopsModel : NSObject
@property (nonatomic, copy) NSString* addr;
@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* longitude;
@property (nonatomic, copy) NSString* lat;
@property (nonatomic, copy) NSString *tel;
@end
