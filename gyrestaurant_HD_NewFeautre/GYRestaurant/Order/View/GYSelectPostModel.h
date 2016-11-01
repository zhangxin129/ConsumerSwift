//
//  GYSelectPostModel.h
//  GYRestaurant
//
//  Created by apple on 15/10/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYSelectPostModel : NSObject

@property(nonatomic, strong) NSString *retCode;
@property(nonatomic, strong) NSString *msg;
@property(nonatomic, strong) NSString *rows;
@property(nonatomic, strong) NSString *totalPage;
@property(nonatomic, strong) NSString *currentPage;
@property(nonatomic, strong) NSMutableArray *data;

@end
