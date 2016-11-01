//
//  GYShopItem.h
//  HSConsumer
//
//  Created by apple on 15-3-5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYShopItem : NSObject
@property (nonatomic, copy) NSString* strShopId;
@property (nonatomic, copy) NSString* strShopName;
@property (nonatomic, copy) NSString* strAddr;
@property (nonatomic, copy) NSString* strLat;
@property (nonatomic, copy) NSString* strLongitude;
@property (nonatomic, copy) NSString* strTel;
@property (nonatomic, copy) NSString* strDistance;
@end
