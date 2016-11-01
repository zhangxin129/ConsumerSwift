//
//  GYHSBankListModel.m
//  HSCompanyPad
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSBankListModel.h"
#import "GYAreaHttpTool.h"

@implementation GYHSBankListModel
- (void)getLocation:(void (^)(NSString* local))location
{
    [GYAreaHttpTool queryCityNameWithCountryNo:self.countryCode provinceNo:self.provinceCode cityNo:self.cityCode success:^(id responsObject) {
        _openArea = responsObject;
        if (location) {
            location(responsObject);
        }
        
    } failure:nil];
}

@end
