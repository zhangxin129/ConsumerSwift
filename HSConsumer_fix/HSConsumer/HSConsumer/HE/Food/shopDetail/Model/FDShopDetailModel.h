//
//  FDShopDetailModel.h
//  HSConsumer
//
//  Created by apple on 15/12/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FDShopDetailModel : JSONModel
@property (nonatomic, copy) NSString* addall;
@property (nonatomic, copy) NSString* introduce;
@property (nonatomic, copy) NSString* reservePhoneNo;
@property (nonatomic, copy) NSString* shopName;
@property (nonatomic, assign) BOOL tickets;
@property (nonatomic, assign) BOOL takeOut;
@property (nonatomic, assign) BOOL appointment;
@property (nonatomic, assign) BOOL parking;
@property (nonatomic, assign) BOOL pickUp;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, copy) NSString* sendPriceMin;
@property (nonatomic, copy) NSString* costAvg;
@property (nonatomic, copy) NSString* costSend;
@property (nonatomic, copy) NSString* mealType;
@property (nonatomic, copy) NSString* openingHours;
@property (nonatomic, copy) NSString* orderHours;
@property (nonatomic, copy) NSString* pics;
@property (nonatomic, copy) NSString* commentCount;
@property (nonatomic, copy) NSString* landmark;
@property (nonatomic, copy) NSString* businessType;
@property (nonatomic, copy) NSString* brand;
@property(nonatomic, copy) NSString *foodTypes;
@end
