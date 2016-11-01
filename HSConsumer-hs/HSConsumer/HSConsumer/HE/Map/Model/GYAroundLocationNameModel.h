//
//  GYAroundLocationNameModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/11/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYAroundLocationNameModel : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) NSArray* arrData;
@end

@interface GYAroundLocationNameDetailModel : NSObject
@property (nonatomic, copy) NSString *name;
@end