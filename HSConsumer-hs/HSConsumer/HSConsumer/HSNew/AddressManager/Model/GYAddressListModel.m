//
//  GYAddressListModel.m
//  HSConsumer
//
//  Created by lizp on 2016/10/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddressListModel.h"
#import "GYAddressListHeightModel.h"
#import "GYHSTools.h"

@interface GYAddressListModel()

@property (nonatomic,assign) CGSize size;

@end

@implementation GYAddressListModel



+(JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"id":@"idString"}];
}

-(GYAddressListModel *)dataWithDic:(NSDictionary *)dic isFood:(BOOL)isFood {

    GYAddressListModel* model = [[GYAddressListModel alloc] initWithDictionary:dic error:nil];
    self.heightModel = [[GYAddressListHeightModel alloc] init];
    NSString* attribString;
    //直辖市直接显示市
    if ([model.province containsString:kLocalized(@"GYHS_Address_Beijing")] || [model.province containsString:kLocalized(@"GYHS_Address_Tianjing")] || [model.province containsString:kLocalized(@"GYHS_Address_Shanghai")] || [model.province containsString:kLocalized(@"GYHS_Address_Chongqing")]) {
        attribString = [NSString stringWithFormat:@"%@%@%@", model.city, model.area, model.address];
    }
    else {
        attribString = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.area, model.address];
    }
    
//    if (isFood) {
//        //直辖市直接显示市
//        if ([model.province containsString:kLocalized(@"GYHS_Address_Beijing")] || [model.province containsString:kLocalized(@"GYHS_Address_Tianjing")] || [model.province containsString:kLocalized(@"GYHS_Address_Shanghai")] || [model.province containsString:kLocalized(@"GYHS_Address_Chongqing")]) {
//            attribString = [NSString stringWithFormat:@"%@%@%@", model.city, model.area, model.address];
//        }
//        else {
//            attribString = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.area, model.address];
//        }
//    }
//    else {
//        
//        GYAddressData* address = [GYAddressData shareInstance];
//        GYProvinceModel* provinceModel = [address queryProvinceNo:model.provinceNo];
//        GYCityAddressModel* cityModel = [address queryCityNo:model.cityNo];
//        
//        if ([provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Beijing")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Tianjing")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Shanghai")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Chongqing")]) {
//            if (model.postCode.length != 0) {
//                attribString = [NSString stringWithFormat:@"%@%@(%@)", cityModel.cityName, model.address, model.postCode];
//            }
//            else {
//                attribString = [NSString stringWithFormat:@"%@%@", cityModel.cityName, model.address];
//            }
//        }
//        else {
//            if (model.postcode.length != 0) {
//                attribString = [NSString stringWithFormat:@"%@%@%@%@(%@)", provinceModel.provinceName, cityModel.cityName, model.area, model.address, model.postcode];
//            }
//            else {
//                attribString = [NSString stringWithFormat:@"%@%@%@%@", provinceModel.provinceName, cityModel.cityName, model.area, model.address];
//            }
//        }
//    }
    
    self.size = [GYUtils sizeForString:model.phone font:kAddressModelMobileFont width:kScreenWidth];
    
    if (isFood) {
        self.heightModel.phoneLabelFrame = CGRectMake(12, 15, self.size.width, 16);
        self.size = [GYUtils sizeForString:attribString font:kAddressModelAddressFont width:kScreenWidth - 12 -12];
        self.heightModel.addressLabelFrame = CGRectMake(12, self.heightModel.phoneLabelFrame.origin.y + self.heightModel.phoneLabelFrame.size.height + 10, self.size.width, self.size.height+15);
    }else {
        self.heightModel.phoneLabelFrame = CGRectMake(kScreenWidth - 12 -self.size.width, 15, self.size.width, 16);
        self.size = [GYUtils sizeForString:model.receiverName font:kAddressModelMobileFont width:kScreenWidth - self.heightModel.phoneLabelFrame.size.width - 12 -12 -10];
        self.heightModel.nameLabelFrame = CGRectMake(12, 10, self.size.width, self.size.height);
        self.size = [GYUtils sizeForString:attribString font:kAddressModelAddressFont width:kScreenWidth - 12 -12];
        self.heightModel.addressLabelFrame = CGRectMake(12, self.heightModel.nameLabelFrame.origin.y + self.heightModel.nameLabelFrame.size.height + 10, self.size.width, self.size.height+15);
    }
    
    self.heightModel.cellHeight = 61 + self.heightModel.addressLabelFrame.origin.y + self.size.height;
    
    model.heightModel = self.heightModel;
    return model;
}

@end
