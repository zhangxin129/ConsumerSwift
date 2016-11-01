//
//  GYShopGoodListModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
typedef void (^CompletionBlock)(NSArray* goodsList, NSError* error);

#import "JSONModel.h"

@interface GYShopGoodListModel : JSONModel
@property (nonatomic, copy) NSString* itemId;
@property (nonatomic, copy) NSString* itemName;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, copy) NSString* pv;
@property (nonatomic, copy) NSString* rate;
@property (nonatomic, copy) NSString* salesCount;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* shopId;

+ (void)loadDataFromNetWorkWithParams:(NSDictionary*)params Complection:(CompletionBlock)block;
@end
