//
//  FDSearchFoodsModel.h
//  HSConsumer
//
//  Created by apple on 15/12/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FDSearchFoodsModel : JSONModel

@property (nonatomic, copy) NSString* dist;
@property (nonatomic, copy) NSString* itemName;
@property (nonatomic, copy) NSString* itemId;
@property (nonatomic, copy) NSString* itemPics;
@property (nonatomic, copy) NSString* shopId;
@property (nonatomic, copy) NSString* shopName;
@property (nonatomic, copy) NSString* vShopId;
@property (nonatomic, copy) NSString* itemPv;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, assign) NSInteger itemSale;
@property (copy, nonatomic) NSString* sendRange;
@property (assign, nonatomic) BOOL isInSendRange;
@property(assign, nonatomic) NSInteger score;

@end
