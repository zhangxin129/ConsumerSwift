//
//  GYHDApplicantListModel.m
//  HSConsumer
//
//  Created by shiang on 16/4/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDApplicantListModel.h"
#import "GYHDMessageCenter.h"

@implementation GYHDApplicantListModel

- (instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        [self setupWithDict:dict];
    }
    return self;
}

- (void)setupWithDict:(NSDictionary*)dict
{
    NSMutableDictionary* bodyDict = [GYUtils stringToDictionary:dict[GYHDDataBaseCenterPushMessageBody]].mutableCopy;

    _applicantHeadImageUrlString = bodyDict[@"msg_icon"];

    _applicantCont = bodyDict[@"reqInfo"];
    _applicantCode = dict[GYHDDataBaseCenterPushMessageCode];
    _applicantID = dict[GYHDDataBaseCenterPushMessageFromID];
    _applicantMessageID = dict[GYHDDataBaseCenterPushMessageID];
    NSMutableDictionary* selectDict = [NSMutableDictionary dictionary];
//    NSString *fromdID = nil;
//    if ([_applicantID hasPrefix:@"nc_"]) {
//        fromdID = [_applicantID substringFromIndex:3];
//        NSMutableString *name = [NSMutableString stringWithString:bodyDict[@"msg_note"]];
//        [name replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//        _applicantNikeNameString = name;
//        bodyDict[@"msg_note"]= name;
//    }else if ([_applicantID hasPrefix:@"c_"]){
//        fromdID = [_applicantID substringFromIndex:2];
//    }else {
//        fromdID = _applicantID;
//    }
    _applicantNikeNameString =  bodyDict[@"msg_note"];
//    selectDict[GYHDDataBaseCenterFriendCustID] =  bodyDict[@"msg_note"];

    if (bodyDict[@"status"]) {
        _applicantUserStatus = [bodyDict[@"status"] integerValue];
    }
    else {
        _applicantUserStatus = 0;
    }
    _applicantBody = dict[GYHDDataBaseCenterPushMessageBody];
    //    _applicantUserStatus =  dict[@""];
    //    _applicantID =  dict[@""];
}

@end
