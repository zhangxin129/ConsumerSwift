//
//  GYHDFriendTeamModel.m
//  HSConsumer
//
//  Created by shiang on 16/3/21.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYHDFriendTeamModel.h"

@implementation GYHDFriendTeamModel
- (instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        _teamID = dict[@"teamId"];
        _teamName = dict[@"teamName"];
    }
    return self;
}

@end
