//
//  FDOrderDetailFoodModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/10/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "JSONModel+LoadData.h"

@interface FDSubmitCommitOrderDetailFoodModel : JSONModel
@property (copy, nonatomic) NSString* foodId;
@property (copy, nonatomic) NSString* foodName;
@property (copy, nonatomic) NSDictionary* foodFormat;
@property (copy, nonatomic) NSString* foodNum;
@property (copy, nonatomic) NSString* foodPrice;
@property (copy, nonatomic) NSString* foodPoint;
@property (nonatomic, copy) NSString* foodPic;
@property (nonatomic, copy) NSString* recomdCount;
@property (nonatomic, copy) NSString* picUrl;
@property (nonatomic, copy) NSString* recommendationItemCount;
@end
