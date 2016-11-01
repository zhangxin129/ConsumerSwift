//
//  GYHESCCartListModel.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/22.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHESCCartListModel.h"

@implementation GYHESCCartListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShowMore = YES; //默认显示更多
    }
    return self;
}

@end
