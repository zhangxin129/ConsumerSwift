//
//  GYGoodCategoryModel.h
//  HSConsumer
//
//  Created by apple on 15-1-20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYGoodCategoryModel : NSObject
@property (nonatomic, copy) NSString* strCategoryTitle;
@property (nonatomic, copy) NSString* strCategoryId;
@property (nonatomic, strong) NSMutableArray* marrSubCategory;

@end
