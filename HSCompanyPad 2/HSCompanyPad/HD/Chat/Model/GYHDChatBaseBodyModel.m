//
//  GYHDChatBaseBodyModel.m
//
//  Created by wangbiao on 16/8/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDChatBaseBodyModel.h"


@implementation GYHDChatBaseBodyModel

- (instancetype)init {
    if (self = [super init]) {
        _msg_type = @"2";
        _sub_msg_code = @"10101";
    }
    return self;
}
- (NSString *)jsonString {
    return @"";
}
@end
