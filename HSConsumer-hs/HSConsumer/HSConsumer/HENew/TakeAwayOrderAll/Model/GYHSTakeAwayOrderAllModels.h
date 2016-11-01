//
//  GYHSTakeAwayOrderAllModels.h
//  HSConsumer
//
//  Created by zhengcx on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GYHSTakeAwayModels
@end

@interface  GYHSTakeAwayModels: JSONModel

@property(nonatomic, assign)NSInteger actuallyAmount;
@property(nonatomic, assign)NSInteger createTime;
@property(nonatomic, copy)NSString *itemIds;
@property(nonatomic, copy)NSString *logo;
@property(nonatomic, copy)NSString *mobile_pic;
@property(nonatomic, copy)NSString *orderCode;
@property(nonatomic, copy)NSString *orderTitle;
@property(nonatomic, copy)NSString *reservationTime;
@property(nonatomic, copy)NSString *shopId;
@property(nonatomic, copy)NSString *shopName;
@property(nonatomic, copy)NSString *skus;
@property(nonatomic, assign)NSInteger status;
@property(nonatomic, assign)NSInteger totalPoints;
@property(nonatomic, assign)NSInteger num;

@end


@interface GYHSTakeAwayOrderAllModels : JSONModel

@property (nonatomic, copy)NSString *tfs;
@property (copy, nonatomic)NSArray<GYHSTakeAwayModels> *orderList;

@end
