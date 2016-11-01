//
//  FDTakeawayShopModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

@protocol FDShopModel

@end

#import "JSONModel+LoadData.h"

@interface FDShopModel : JSONModel

@property (copy, nonatomic) NSString* shopAddr;
@property (copy, nonatomic) NSString* shopId;
@property (copy, nonatomic) NSString* shopPic;
@property (copy, nonatomic) NSString* shopEvgPrice;
@property (copy, nonatomic) NSString* shopPoint;
@property (copy, nonatomic) NSString* shopName;
@property (assign, nonatomic) BOOL tickets;
@property (assign, nonatomic) BOOL parking;
@property (assign, nonatomic) BOOL appointment;
@property (assign, nonatomic) BOOL pickUp;
@property (assign, nonatomic) BOOL takeOut;
@property (copy, nonatomic) NSString* vShopId;
@property (copy, nonatomic) NSString* shopDistance;
@property (copy, nonatomic) NSString* shopLandmark;
@property (copy, nonatomic) NSString* sendPrice;
@property (copy, nonatomic) NSString* costSend;
@property (copy, nonatomic) NSString* fullOffDesc;
@property (copy, nonatomic) NSString* qiSongPrice;
@property (nonatomic, copy) NSString* fullPrice;
@property (nonatomic, copy) NSString* offPrice;
@property (copy, nonatomic) NSString* sendRange;
@property (assign, nonatomic) BOOL isInSendRange;
@property (copy, nonatomic) NSString* mealType;
@property (nonatomic, copy) NSString* businessType;
//@property(nonatomic,copy)NSString*foodTypes;
@end
