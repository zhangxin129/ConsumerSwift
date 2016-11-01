//
//  GYAroundShopsCategoryModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/11/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYAroundShopsCategoryModel : NSObject
@property (nonatomic, copy) NSString* categoryId;
@property (nonatomic, copy) NSString* categoryName;
@property (nonatomic, copy) NSString* cid;
@property (nonatomic, strong) NSArray* listMap;
@property (nonatomic, assign) BOOL isShowAll;
@end

@interface GYAroundShopsCategorySubModel : NSObject
@property (nonatomic, copy) NSString* categoryId;
@property (nonatomic, copy) NSString* categoryName;
@property (nonatomic, copy) NSString *cid;
@end