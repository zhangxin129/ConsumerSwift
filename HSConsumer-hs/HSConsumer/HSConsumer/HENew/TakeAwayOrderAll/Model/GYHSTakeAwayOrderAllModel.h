//
//  GYHSTakeAwayAllModel.h
//  HSConsumer
//
//  Created by kuser on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

///// cell数据
@protocol GYHSTakeAwayOrderCellModel
@end

@interface GYHSTakeAwayOrderCellModel : JSONModel

//图标
@property (nonatomic, copy) NSString* url;
//标题
@property (nonatomic, copy) NSString* title;
//订单号
@property (nonatomic, copy) NSString* orderDetailId;
//详细时间
@property (nonatomic, copy) NSString* detailTime;
//金额
@property (nonatomic, copy) NSString* price;
//积分
@property (nonatomic, copy) NSString* pv;
//状态
@property (nonatomic, copy) NSString* statu;

@end

///// section数据
@protocol GYHSTakeAwayOrderCellSectionModel
@end

@interface GYHSTakeAwayOrderCellSectionModel : JSONModel

@property (nonatomic, copy) NSString* shopName; //商店名字
@property (nonatomic, copy) NSString* status; //商品状态
@property (nonatomic, copy) NSString* shopUrl; //商店图标
@property (nonatomic, strong) NSArray<GYHSTakeAwayOrderCellModel>* items;
@end

/////  all数据
@interface GYHSTakeAwayOrderAllModel : JSONModel

@property (nonatomic, strong) NSArray<GYHSTakeAwayOrderCellSectionModel>* data;

@end

