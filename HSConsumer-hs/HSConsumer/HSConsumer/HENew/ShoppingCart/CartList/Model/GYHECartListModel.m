//
//  GYHECartListModel.m
//  HSConsumer
//
//  Created by User on 16/10/25.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHECartListModel.h"

@implementation GYHECartItemModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isAdd = YES;
        self.isSub = YES;
    }
    return self;
}

//+ (JSONKeyMapper*)keyMapper
//{
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"picUrl": @"itemInfos.pics.(p200x200)"}];
//}

@end


@implementation GYHECartListModel

@end
