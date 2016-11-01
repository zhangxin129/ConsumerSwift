//
//  GYHDSearchUserModel.m
//  HSConsumer
//
//  Created by wangbiao on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchUserModel.h"

@implementation GYHDSearchUserModel

@end

@implementation GYHDSearchUserGroupModel

- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

@end