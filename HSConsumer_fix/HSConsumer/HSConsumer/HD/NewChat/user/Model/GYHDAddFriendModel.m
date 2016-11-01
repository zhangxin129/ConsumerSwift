//
//  GYHDAddFriendModel.m
//  HSConsumer
//
//  Created by shiang on 16/3/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAddFriendModel.h"

@implementation GYHDAddFriendModel

- (instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        [self setupWithDict:dict];
    }
    return self;
}

- (void)setupWithDict:(NSDictionary*)dict
{

    self.addUserStatus = [dict[@"friendStatus"] integerValue];
    self.addExtraMessage = dict[@"req_info"];
    NSMutableDictionary* infoDict = [NSMutableDictionary dictionaryWithDictionary:dict[@"searchUserInfo"]];
    if (self.addExtraMessage.length< 1) {
        self.addExtraMessage = infoDict[@"sign"];
    }
    if ([infoDict[@"userType"] integerValue] == 1) {
        self.addfriendID = [NSString stringWithFormat:@"c_%@", infoDict[@"custId"]];
           self.addNikeNameString = infoDict[@"nickName"];
    }
    else {
        self.addfriendID = [NSString stringWithFormat:@"nc_%@", infoDict[@"custId"]];
        if ( [infoDict[@"nickName"] isEqualToString:infoDict[@"resNo"]]) {
            NSMutableString *name = [NSMutableString stringWithString:infoDict[@"nickName"]];
            [name replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            self.addNikeNameString = name;
            infoDict[@"nickName"] = name;
        }else {
            self.addNikeNameString = infoDict[@"nickName"]; 
        }
     
    }
    if ([infoDict[@"headImage"] hasPrefix:@"http"]) {
        self.addHeadImageUrlString = infoDict[@"headImage"];
    }
    else {
        self.addHeadImageUrlString = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, infoDict[@"headImage"]];
    }
     _addDobyDict = infoDict;
}

@end
