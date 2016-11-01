//
//  GYHDMoveFriendGroupModel.m
//  HSConsumer
//
//  Created by shiang on 16/3/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMoveFriendGroupModel.h"
#import "GYHDMessageCenter.h"

@implementation GYHDMoveFriendGroupModel
- (NSMutableArray*)moveFriendArray
{
    if (!_moveFriendArray) {
        _moveFriendArray = [NSMutableArray array];
    }
    return _moveFriendArray;
}

@end

@implementation GYHDMoveFriendModel
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init]) {
        _moveFriendAccountID = dict[GYHDDataBaseCenterFriendFriendID];
        _moveFriendIconUrl = dict[GYHDDataBaseCenterFriendIcon];
        _moveFriendNikeName = dict[GYHDDataBaseCenterFriendName];
        _moveFriendTeamID = dict[GYHDDataBaseCenterFriendInfoTeamID];
        _moveFriendSelectState = NO;
    }
    return self;
}

@end