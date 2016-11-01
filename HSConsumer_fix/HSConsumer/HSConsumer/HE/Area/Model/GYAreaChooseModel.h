//
//  GYAreaChooseModel.h
//  HSConsumer
//
//  Created by lizp on 16/6/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYAreaChooseModel : JSONModel <NSCoding>

@property (nonatomic, copy) NSString<Optional>* areaCode;
@property (nonatomic, copy) NSString<Optional>* areaName;
@property (nonatomic, copy) NSString<Optional>* enName;
@property (nonatomic, copy) NSString<Optional>* parentCode;
@property (nonatomic, copy) NSString<Optional>* sortOrder;

@end
