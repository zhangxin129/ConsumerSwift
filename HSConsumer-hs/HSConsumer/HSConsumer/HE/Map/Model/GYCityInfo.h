//
//  GYCityInfo.h
//  HSConsumer
//
//  Created by apple on 15-2-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYCityInfo : NSObject
@property (nonatomic, copy) NSString* strAreaCode;
@property (nonatomic, copy) NSString* strAreaName;
@property (nonatomic, copy) NSString* strAreaType;
@property (nonatomic, copy) NSString* strAreaParentCode;
@property (nonatomic, copy) NSString* strAreaSortOrder;
// add by songjk
@property (nonatomic, copy) NSString *strEnName;
@end
