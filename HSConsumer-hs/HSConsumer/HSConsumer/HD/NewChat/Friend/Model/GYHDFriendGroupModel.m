//
//  GYHDFriendGroupModel.m
//  HSConsumer
//
//  Created by shiang on 16/3/21.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYHDFriendGroupModel.h"

@implementation GYHDFriendGroupModel

- (NSMutableArray*)friendGroupArray
{
    if (!_friendGroupArray) {
        _friendGroupArray = [NSMutableArray array];
    }
    return _friendGroupArray;
}

@end
