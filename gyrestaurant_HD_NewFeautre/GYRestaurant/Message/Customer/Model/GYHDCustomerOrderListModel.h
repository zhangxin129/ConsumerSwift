//
//  GYHDCustomerOrderListModel.h
//  GYRestaurant
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDCustomerOrderListModel : NSObject
@property(nonatomic,copy)NSString*vshopName;//营业点id
@property(nonatomic,copy)NSString*createTime;//下单时间
@property(nonatomic,copy)NSString*orderStatus;//订单状态
@property(nonatomic,copy)NSString*userId;//用户id
@property(nonatomic,copy)NSString*orderId;//订单id
@property(nonatomic,copy)NSString*orderType;//订单类型

/* 传输订单详情页面数据*/
//订单状态
@property (nonatomic,copy) NSString *orderStatusN;
//订单类型
@property (nonatomic, copy)NSString *orderTypeStr;


-(void)initModelWithDict:(NSDictionary*)dict;
@end
