//
//  GYHSLocalInfoModel.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/24.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GYHSLocalInfoModel : JSONModel <NSCoding>

// 本地国名
@property (nonatomic, copy) NSString* countryName;
// 本地国名全称
@property (nonatomic, copy) NSString* countryNameCn;

// 本地国家编号
@property (nonatomic, copy) NSString* countryNo;

// 平台称呼
@property (nonatomic, copy) NSString* platNameCn;

@property (nonatomic, copy) NSString* platNo;

@end
