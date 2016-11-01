//
//  GYProvinceViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

typedef NS_ENUM(NSInteger, cityType) {
    cityTypePush,
    cityTypePop
};

@class GYCityAddressModel;

@protocol GYCityAddressViewControllerDelegate <NSObject>

@optional
- (void)returnPopCity:(GYCityAddressModel*)model;

@end

#import <UIKit/UIKit.h>

@interface GYCityAddressViewController : GYViewController
@property (nonatomic, strong) NSMutableArray* marrSourceData;
@property (nonatomic, copy) NSMutableString* mstrCountryAndProvince;
@property (nonatomic, copy) NSString* areaIdString;
@property (nonatomic, copy) NSString* areaIdcounyry;

@property (nonatomic, assign) cityType type;
@property (nonatomic, weak) id<GYCityAddressViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString* countryName;
@property (nonatomic, copy) NSString* ProvinceName;

@end
