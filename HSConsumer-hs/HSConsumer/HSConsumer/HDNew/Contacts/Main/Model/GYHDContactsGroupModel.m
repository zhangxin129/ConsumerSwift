//
//  GYHDContactsGroupModel.m
//  HSConsumer
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDContactsGroupModel.h"

@implementation GYHDContactsGroupModel
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
@end
