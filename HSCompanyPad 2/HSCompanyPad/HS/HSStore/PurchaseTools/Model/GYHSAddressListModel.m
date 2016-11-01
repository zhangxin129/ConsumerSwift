//
//  GYToolApplyAddressNewModel.m
//  company
//
//  Created by apple on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAddressListModel.h"
#import <MJExtension/MJExtension.h>
#import "GYAreaHttpTool.h"
@implementation GYHSAddressListModel
//- (void)setCityModel:(GYCityAddressModel *)cityModel {
//    _cityModel = cityModel;
//    [GYAreaHttpTool queryCityINfoWithNo:self.cityNo success:^(id responsObject) {
//        cityModel = (GYCityAddressModel*)responsObject;
//    } failure:^{
//
//    }];
//
//}
- (void)getDetailArressWithBlock:(void (^)(NSString* address))block
{
    if (block) {
    
        @weakify(self);
        [GYAreaHttpTool queryCityNameWithCountryNo:nil provinceNo:self.provinceNo cityNo:self.cityNo success:^(id responsObject) {
            @strongify(self);
            if (self.postCode.length > 1) {
                block( [NSString stringWithFormat:@"%@%@(%@)",responsObject,kSaftToNSString(self.contactAddr),kSaftToNSString(self.postCode)]);
            }else {
                block( [NSString stringWithFormat:@"%@%@",responsObject,kSaftToNSString(self.contactAddr)]);
                
            }
        } failure:^{
            
        }];
        
            
   
    }
}

+ (NSDictionary*)mj_replacedKeyFromPropertyName
{

    return @{ @"addressId" : @"id" };
}
@end
@implementation GYHSAddressDetailModel

@end
