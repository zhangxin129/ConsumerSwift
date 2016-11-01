//
//  GYHDFriendGroupModel.m
//  HSConsumer
//
//  Created by shiang on 16/3/21.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYHDOperGroupModel.h"

@implementation GYHDOperGroupModel

- (NSMutableArray *)operGroupArray {
    if (!_operGroupArray) {
        _operGroupArray = [NSMutableArray array];
    }
    return _operGroupArray;
}
@end
