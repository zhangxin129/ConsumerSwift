//
//  GYHSPointCheckModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GYHSConstant.h"

@interface GYHSPointCheckModel : JSONModel
@property (nonatomic,copy) NSString * entResNo;//企业互生号
@property (nonatomic,copy) NSString * transNo;//交易流水号
@property (nonatomic,copy) NSString * perResNo;//消费者互生号
@property (nonatomic,copy) NSString * transAmount;//交易金额(消费金额/退货金额)
@property (nonatomic,copy) NSString * pointRate;//积分比例
@property (nonatomic,copy) NSString * perPoint;//消费者积分(积分金额)
@property (nonatomic,copy) NSString * entPoint;//企业积分应付款(积分金额退回)
@property (nonatomic,copy) NSString * channelType;//渠道类型
@property (nonatomic,copy) NSString * equipmentType;//设备类型
@property (nonatomic,copy) NSString * remark;//备注
@property (nonatomic,copy) NSString * sourceTransDate;//原始交易时间
@property (nonatomic,copy) NSString * sourceTransAmount;//原始交易金额(退货消费金额)
@property (nonatomic,copy) NSString * sourcePerPoint;//原始消费积分(退货消费积分)
@property (nonatomic,assign) kPointCheck checkType;//查询类型
@end
