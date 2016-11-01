//
//  GYTicketAccountModel.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYTicketAccountModel : JSONModel

@property (nonatomic, copy)NSString * couponName ;//抵扣券
@property (nonatomic, copy)NSString *expEnd ;//有效期
@property (nonatomic, copy)NSString *faceValue ;// 面值
@property (nonatomic, copy)NSString *id ;// 2910803155518464;
@property (nonatomic, copy)NSString *surplusNumber ;//可用数量
@property (nonatomic, copy)NSString *usedNumber ;//已用数量

@end
