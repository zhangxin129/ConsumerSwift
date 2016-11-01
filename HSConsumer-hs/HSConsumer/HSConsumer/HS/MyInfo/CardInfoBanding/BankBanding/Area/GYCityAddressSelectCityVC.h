//
//  GYCityAddressSelectCityVC.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSCityAddressModel;
@protocol CitySelectDelegate <NSObject>

@optional
- (void)didSelectCityModel:(GYHSCityAddressModel*)model;

@end

@interface GYCityAddressSelectCityVC : GYViewController

@property (nonatomic, copy) NSString* areaId;
@property (nonatomic, copy) NSString* provinceNO;
@property (nonatomic, copy) NSMutableString* countryProvinceInfo;
@property (nonatomic, strong) NSIndexPath* selectIndexPath;

@property (nonatomic, weak) id<CitySelectDelegate> delegate;
@property (nonatomic) BOOL isFromAddressVC; //是否父级控制器是收货地址管理

@end
