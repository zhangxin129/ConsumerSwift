//
//  GYHSAddressSelectCityDataController.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYHSCityAddressModel;
typedef void (^GYHSAddressSelectCityBlock)(GYHSCityAddressModel* model);
typedef void (^GYHSAddressSelectAllCitysBlock)(NSArray* citysArray);

@interface GYHSAddressSelectCityDataController : NSObject

// 查询城市列表
- (void)queryCity:(NSString*)countryNo
        prvinceNo:(NSString*)prvinceNo
           cityNo:(NSString*)cityNo
      resultBlock:(GYHSAddressSelectCityBlock)resultBlock;

// 查询省下所有城市
- (void)queyrCitys:(NSString*)countryNo
        privinceNo:(NSString*)privinceNo
       resultBlock:(GYHSAddressSelectAllCitysBlock)resultBlock;

@end
