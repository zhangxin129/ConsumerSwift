//
//  GYHDChatTextBodyModel.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/22.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDChatTextBodyModel.h"
@implementation GYHDChatTextBodyModel
- (NSString *)msg_code {
    return @"00";
}
- (NSString *)jsonString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"msg_code"] = self.msg_code;
    dict[@"msg_type"] = self.msg_type;
    dict[@"sub_msg_code"] = self.sub_msg_code;
    dict[@"msg_icon"] = self.msg_icon;
    dict[@"msg_note"] = self.msg_note;
    dict[@"msg_content"] = self.msg_content;
    return [GYHDUtils dictionaryToString:dict];
}
@end
