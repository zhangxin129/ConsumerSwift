//
//  GYHDChatLocationBodyModel.m
//  HSCompanyPad
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDChatLocationBodyModel.h"

@implementation GYHDChatLocationBodyModel

/*
 @property(nonatomic,copy)NSString*map_lng;
 @property(nonatomic,copy)NSString*map_lat;
 @property(nonatomic,copy)NSString*map_address;
 @property(nonatomic,copy)NSString*map_name;
 @property(nonatomic,copy)NSString*map_poi;
 */
- (NSString *)msg_code {
    return @"11";
}
- (NSString *)jsonString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"msg_code"] = self.msg_code;
    dict[@"msg_type"] = self.msg_type;
    dict[@"sub_msg_code"] = self.sub_msg_code;
    dict[@"msg_icon"] = self.msg_icon;
    dict[@"msg_note"] = self.msg_note;
    dict[@"msg_content"] = self.msg_content;
    dict[@"map_lng"] = self.map_lng;
    dict[@"map_lat"] = self.map_lat;
    dict[@"map_address"] = self.map_address;
    dict[@"map_name"] = self.map_name;
    dict[@"map_poi"] = self.map_poi;
    return [GYHDUtils dictionaryToString:dict];
}
@end
