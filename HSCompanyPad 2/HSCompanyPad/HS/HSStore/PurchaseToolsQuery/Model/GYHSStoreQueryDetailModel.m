//
//  GYHSStoreQueryDetailModel.m
//  HSCompanyPad
//
//  Created by cook on 16/9/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSStoreQueryDetailModel.h"
#import <MJExtension/MJExtension.h>



@implementation GYHSStoreQueryDetailModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"confsInfo":@"GYHSStoreConfsModel",@"afterDetail":@"GYHSStoreToolAfterDetailModel"};
}

@end

@implementation GYHSStoreToolAfterDetailModel : NSObject

@end

@implementation GYHSStoreDeliverInfoModel
- (NSString *)address
{
    if (([_address hasPrefix:@"null"]|| [_address hasPrefix:@"NULL"]) && _address.length > 4) {
        return @"--";
    }
    return _address;
}

@end
@implementation GYHSStoreConfsModel

@end

@implementation GYHSStoreOrderInfoModel

@end
