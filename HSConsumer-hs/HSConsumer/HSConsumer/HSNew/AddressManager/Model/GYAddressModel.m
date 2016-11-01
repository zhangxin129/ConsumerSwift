//
//  GYAddressModel.m
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddressModel.h"
#import "GYCityAddressModel.h"
#import "GYProvinceModel.h"
#import "GYAddressHeightModel.h"
#import "GYAddressData.h"
#import "GYHSTools.h"

#define kLeftEdge 12.0f
#define kRightEdge 27.0f
#define kTextHeight 8.0f
#define kTopEdge 16.0f
#define kBottonEdge 16.0f

@interface GYAddressModel ()

@property (nonatomic, assign) CGSize size;

@end

@implementation GYAddressModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"id" : @"idString" }];
}


- (GYAddressModel*)dataWithDic:(NSDictionary*)dic isFood:(BOOL)isFood {

    GYAddressModel* model = [[GYAddressModel alloc] initWithDictionary:dic error:nil];
    self.heightModel = [[GYAddressHeightModel alloc] init];
    NSString* attribString;
    if (isFood) {
        //直辖市直接显示市
        if ([model.province containsString:kLocalized(@"GYHS_Address_Beijing")] || [model.province containsString:kLocalized(@"GYHS_Address_Tianjing")] || [model.province containsString:kLocalized(@"GYHS_Address_Shanghai")] || [model.province containsString:kLocalized(@"GYHS_Address_Chongqing")]) {
            attribString = [NSString stringWithFormat:@"%@%@%@", model.city, model.area, model.detail];
        }
        else {
            attribString = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.area, model.detail];
        }
    }
    else {
        
        GYAddressData* address = [GYAddressData shareInstance];
        GYProvinceModel* provinceModel = [address queryProvinceNo:model.provinceNo];
        GYCityAddressModel* cityModel = [address queryCityNo:model.cityNo];
        
        if ([provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Beijing")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Tianjing")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Shanghai")] || [provinceModel.provinceName containsString:kLocalized(@"GYHS_Address_Chongqing")]) {
            if (model.postCode.length != 0) {
                attribString = [NSString stringWithFormat:@"%@%@(%@)", cityModel.cityName, model.address, model.postCode];
            }
            else {
                attribString = [NSString stringWithFormat:@"%@%@", cityModel.cityName, model.address];
            }
        }
        else {
            if (model.postCode.length != 0) {
                attribString = [NSString stringWithFormat:@"%@%@%@%@(%@)", provinceModel.provinceName, cityModel.cityName, model.area, model.address, model.postCode];
            }
            else {
                attribString = [NSString stringWithFormat:@"%@%@%@%@", provinceModel.provinceName, cityModel.cityName, model.area, model.address];
            }
        }
    }
    
    self.size = [GYUtils sizeForString:model.mobile font:kAddressModelMobileFont width:kScreenWidth];
    
    if (isFood) {
        self.heightModel.phoneLabelFrame = CGRectMake(12, 15, self.size.width, 16);
        self.size = [GYUtils sizeForString:attribString font:kAddressModelAddressFont width:kScreenWidth - 12 -12];
        self.heightModel.addressLabelFrame = CGRectMake(12, self.heightModel.phoneLabelFrame.origin.y + self.heightModel.phoneLabelFrame.size.height + 10, self.size.width, self.size.height+15);
    }else {
        self.heightModel.phoneLabelFrame = CGRectMake(kScreenWidth - 12 -self.size.width, 15, self.size.width, 16);
        self.size = [GYUtils sizeForString:model.receiver font:kAddressModelMobileFont width:kScreenWidth - self.heightModel.phoneLabelFrame.size.width - 12 -12 -10];
        self.heightModel.nameLabelFrame = CGRectMake(12, 15, self.size.width, self.size.height);
        self.size = [GYUtils sizeForString:attribString font:kAddressModelAddressFont width:kScreenWidth - 12 -12];
        self.heightModel.addressLabelFrame = CGRectMake(12, self.heightModel.nameLabelFrame.origin.y + self.heightModel.nameLabelFrame.size.height + 10, self.size.width, self.size.height+15);
    }
   
    if (self.heightModel.addressLabelFrame.origin.y + self.size.height < 70 ) {
        self.heightModel.cellHeight = 116;
//        self.heightModel.arrowImageViewFrame = CGRectMake(kScreenWidth -24 , 27, 16, 16);
    }else {
        self.heightModel.cellHeight = 61 + self.heightModel.addressLabelFrame.origin.y + self.size.height;
//        self.heightModel.arrowImageViewFrame = CGRectMake(kScreenWidth -24 , (self.heightModel.addressLabelFrame.origin.y + self.size.height +15 -16)/2.0, 16, 16);
    }
    model.heightModel = self.heightModel;
    return model;
    
}


@end
