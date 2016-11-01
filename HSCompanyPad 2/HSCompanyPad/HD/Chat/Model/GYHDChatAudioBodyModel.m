//
//  GYHDChatAudioBodyModel.m
//
//  Created by wangbiao on 16/8/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDChatAudioBodyModel.h"

@implementation GYHDChatAudioBodyModel


- (NSString *)msg_code {
    return @"13";
}
- (NSString *)jsonString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"msg_code"] = self.msg_code;
    dict[@"msg_type"] = self.msg_type;
    dict[@"sub_msg_code"] = self.sub_msg_code;
    dict[@"msg_icon"] = self.msg_icon;
    dict[@"msg_note"] = self.msg_note;
    dict[@"msg_content"] = self.msg_content;
    dict[@"msg_fileSize"] = self.msg_fileSize;
    return [GYHDUtils dictionaryToString:dict];
}

@end
