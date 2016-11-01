//
//  FDShopCommitModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "JSONModel+LoadData.h"

@interface FDShopCommitModel : JSONModel

@property (copy, nonatomic) NSString* tasteNum;
@property (copy, nonatomic) NSString* serviceNum;
@property (copy, nonatomic) NSString* evnNum;
@property (copy, nonatomic) NSString* recomNum;
@property (copy, nonatomic) NSString* nickname;
@property (copy, nonatomic) NSString* tastePoint;
@property (copy, nonatomic) NSString* recomFood;
@property (copy, nonatomic) NSString* recomReason;
@property (copy, nonatomic) NSString* comment;
@property (strong, nonatomic) NSArray* picList;
@property (copy, nonatomic) NSString* commentDate;
@property (copy, nonatomic) NSString* goodNum;
@property (assign, nonatomic) BOOL isGood;
@property (copy, nonatomic) NSString* commentId;
@property (copy, nonatomic) NSString* userId;
@property (copy, nonatomic) NSString* shopId;
@property (copy, nonatomic) NSString* vShopId;
@property (copy, nonatomic) NSString* pics;
@property (assign, nonatomic) BOOL hasCard;
@property (copy, nonatomic) NSString* recomId;
@property(assign, nonatomic) NSString *cont;
@end
