//
//  GYHSLoginHistoryModel.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginHistoryModel.h"

@implementation GYHSLoginHistoryModel

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self == [super init]) {
        _userName = [aDecoder decodeObjectForKey:@"_userName"];
        _holderCar = [aDecoder decodeBoolForKey:@"_holderCar"];
        _headPic = [aDecoder decodeObjectForKey:@"_headPic"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_userName forKey:@"_userName"];
    [aCoder encodeBool:_holderCar forKey:@"_holderCar"];
    [aCoder encodeObject:_headPic forKey:@"_headPic"];
}

@end
