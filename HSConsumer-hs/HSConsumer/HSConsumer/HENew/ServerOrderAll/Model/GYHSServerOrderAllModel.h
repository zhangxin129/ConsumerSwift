//
//  GYHSServerOrderAllModel.h
//  HSConsumer
//
//  Created by kuser on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

///// cell数据
@protocol GYHSServerOrderCellModel
@end

@interface GYHSServerOrderCellModel : JSONModel

@property (nonatomic, copy) NSString* url; //图标
@property (nonatomic, copy) NSString* title; //标题
@property (nonatomic, copy) NSString* orderDetailId; //订单号
@property (nonatomic, copy) NSString* time; //预约时间
@property (nonatomic, copy) NSString* detailTime; //详细时间
@property (nonatomic, copy) NSString* price; //金额
@property (nonatomic, copy) NSString* pv; //积分
@property (nonatomic, copy) NSString* statu; //状态
@property (nonatomic, copy) NSString* type; //类型

@end

///// section数据
@protocol GYHSServerOrderCellSectionModel
@end

@interface GYHSServerOrderCellSectionModel : JSONModel

@property (nonatomic, copy) NSString* shopName; //商店名字
@property (nonatomic, copy) NSString* status; //商品状态
@property (nonatomic, copy) NSString* shopUrl; //商店图标
@property (nonatomic, strong) NSArray<GYHSServerOrderCellModel>* items;

@end

/////  all数据
@interface GYHSServerOrderAllModel : JSONModel

@property(nonatomic,strong)NSArray <GYHSServerOrderCellSectionModel> *data;

@end
