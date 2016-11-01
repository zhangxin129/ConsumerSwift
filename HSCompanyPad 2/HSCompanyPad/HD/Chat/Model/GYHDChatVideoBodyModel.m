//
//  GYHDChatVideoBodyModel.m
//
//  Created by wangbiao on 16/8/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDChatVideoBodyModel.h"

@implementation GYHDChatVideoBodyModel

- (NSString *)msg_code {
    return @"14";
}

- (NSString *)jsonString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"msg_code"] = self.msg_code;
    dict[@"msg_type"] = self.msg_type;
    dict[@"sub_msg_code"] = self.sub_msg_code;
    dict[@"msg_icon"] = self.msg_icon;
    dict[@"msg_note"] = self.msg_note;
    dict[@"msg_content"] = self.msg_content;
    dict[@"msg_imageNail"] = self.msg_imageNail;
    dict[@"msg_imageNailsUrl"] = self.msg_imageNailsUrl;
    dict[@"msg_imageNails_width"] = self.msg_imageNails_width;
    dict[@"msg_imageNails_height"] = self.msg_imageNails_height;
    return [GYHDUtils dictionaryToString:dict];
}
@end
