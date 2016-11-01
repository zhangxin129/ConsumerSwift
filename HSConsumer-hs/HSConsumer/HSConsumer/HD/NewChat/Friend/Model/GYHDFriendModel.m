//
//  GYHDFriendModel.m
//  HSConsumer
//
//  Created by shiang on 16/1/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDFriendModel.h"
#import "GYHDMessageCenter.h"

@interface GYHDFriendModel ()

@end
@implementation GYHDFriendModel
+ (instancetype)friendModelWithDictionary:(NSDictionary*)dict
{

    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary*)dict
{

    self = [super init];
    if (!self)
        return self;
    _FriendAccountID = dict[@"Friend_ID"];
    _FriendIconUrl = dict[@"Friend_Icon"];
    _FriendNickName = dict[@"Friend_Name"];
    _FriendSignature = dict[@"Friend_Sign"];
    _FriendCustID = dict[@"Friend_CustID"];
    _friendTeamID = dict[@"Friend_TeamID"];
    _friendApplicationStatus = dict[GYHDDataBaseCenterFriendApplication];
    _friendApplicationSelectCount = 1;
    NSDictionary *baseDict = [GYUtils stringToDictionary:dict[@"Friend_Basic"]];
    _reqInfoString = baseDict[@"req_info"];
    return self;
}

@end
