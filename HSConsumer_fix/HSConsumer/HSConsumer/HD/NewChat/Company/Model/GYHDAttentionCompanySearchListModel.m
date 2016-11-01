//
//  GYHDAttentionCompanySearchListModel.m
//  HSConsumer
//
//  Created by shiang on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAttentionCompanySearchListModel.h"
#import "GYHDMessageCenter.h"

@implementation GYHDAttentionCompanySearchListModel
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init]) {
        if (dict[@"pic"]) {
            _companyIcon = dict[@"pic"];
        }
        else {
            _companyIcon = dict[@"url"];
        }

        if (dict[@"vShopName"]) {
            _companyTitle = dict[@"vShopName"];
        }
        else {
            _companyTitle = dict[@"companyName"];
        }
        if (dict[@"companyResourceNo"]) {
            _companyDetail = [NSString stringWithFormat:@"%@%@", [GYUtils localizedStringWithKey:@"GYHD_companyHuSheng"],[[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard:dict[@"companyResourceNo"]]];
        }
        else {
            _companyDetail = [NSString stringWithFormat:@"%@%@", [GYUtils localizedStringWithKey:@"GYHD_companyHuSheng"],[[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard:dict[@"resno"]] ];
        }
        if (dict[@"shopId"]) {
            _companyShopID = dict[@"shopId"];
        }
        else {
            _companyShopID = dict[@"id"];
        }
        _companyVshopID = dict[@"vShopId"];
    }
    return self;
}

@end
