//
//  GYBankListModel.m
//  HSConsumer
//
//  Created by apple on 15-1-27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBankListModel.h"

@implementation GYHSBankListModel

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_bankNo forKey:@"bankNo"];
    [aCoder encodeObject:_bankName forKey:@"bankName"];
    [aCoder encodeObject:_delFlag forKey:@"delFlag"];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        _bankNo = [aDecoder decodeObjectForKey:@"bankNo"];
        _bankName = [aDecoder decodeObjectForKey:@"bankName"];
        _delFlag = [aDecoder decodeObjectForKey:@"delFlag"];
    }
    
    return self;
}

@end
