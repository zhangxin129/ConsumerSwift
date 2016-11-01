//
//  GYHDCityGroupModel.h
//  HSConsumer
//
//  Created by shiang on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDCityGroupModel : NSObject

@property (nonatomic, copy) NSString* cityTitle;
@property (nonatomic, strong) NSMutableArray* cityGroupArray;
@end

@interface GYHDCityModel : NSObject

@property (nonatomic, copy) NSString* cityName;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end