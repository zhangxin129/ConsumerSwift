//
//  GYTicketAccountDetailModel.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYTicketAccountDetailModel : JSONModel

@property (nonatomic, copy)NSString * faceValue;
@property (nonatomic, copy)NSString * number;
@property (nonatomic, copy)NSString * id;
@property (nonatomic, copy)NSString * orderNo;
@property (nonatomic, copy)NSString * couponName;
@property (nonatomic, copy)NSString * couponUseTime;
@property (nonatomic, copy)NSString * couponId;

@end
