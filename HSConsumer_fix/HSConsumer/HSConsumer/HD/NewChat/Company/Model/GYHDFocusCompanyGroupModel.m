//
//  GYHDFocusCompanyGroupModel.m
//  HSConsumer
//
//  Created by shiang on 16/3/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDFocusCompanyGroupModel.h"
#import "GYHDMessageCenter.h"

@implementation GYHDFocusCompanyGroupModel
- (NSMutableArray*)focusCompanyGroupArray
{
    if (!_focusCompanyGroupArray) {
        _focusCompanyGroupArray = [NSMutableArray array];
    }
    return _focusCompanyGroupArray;
}

@end

@implementation GYHDFocusCompanyModel
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init]) {
        NSDictionary* friendDetailDict = [GYUtils stringToDictionary:dict[@"Friend_detailed"]];
        _focusCompanyVshopID = friendDetailDict[@"id"];
        _focusCompanyIcon = dict[@"Friend_Icon"];
        _focusCompanyName = dict[@"Friend_Name"];
        _focusCompanyDetail = [NSString stringWithFormat:@"%@%@", [GYUtils localizedStringWithKey:@"GYHD_companyHuSheng"], [[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard: dict[@"Friend_ResourceID"]]];
        _focusCompanyShopID = friendDetailDict[@"shopId"];

        NSDictionary* shopDict = [GYUtils stringToDictionary:dict[@"Friend_Basic"]];
        if (shopDict[@"vShopUrl"]) {
            _focusCompanyUrlString = shopDict[@"vShopUrl"];
        }
        else {
            _focusCompanyUrlString = [NSString stringWithFormat:@"http://%@.hsxt.cn", dict[@"Friend_ResourceID"]];
        }
    }
    return self;
}

@end