//
//  GYSystemSettingModel.h
//  GYRestaurant
//
//  Created by kuser on 15/10/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  营业点模型
 */
@interface GYSystemSettingModel : NSObject
/**
 *  地址
 */
@property (nonatomic, copy) NSString *address;
/**
 *  营业点id
 */
@property (nonatomic, copy) NSString *strID;
/**
 *  营业点名称
 */
@property (nonatomic, copy) NSString *shopName;
@end
