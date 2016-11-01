//
//  GYHEAreaLocationManager.h
//  HSConsumer
//
//  Created by xiaoxh on 16/10/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYHEAreaLocationModel.h"

@interface GYHEAreaLocationManager : NSObject

+(GYHEAreaLocationManager*)shareInstance;

-(NSMutableArray*)returnsAllProvinces;

-(NSMutableArray*)queryProvincesofAllCity:(NSString*)areaCode;

-(NSMutableArray*)queryCitysofAllDistrict:(NSString*)areaCode;
@end
