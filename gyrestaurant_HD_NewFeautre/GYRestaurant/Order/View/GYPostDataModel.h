//
//  GYPostDataModel.h
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYPostDataModel : NSObject

//送餐员电话
@property(nonatomic ,strong) NSString *deliverContact;
//送餐员id
@property(nonatomic ,strong) NSString *deliveryId;
//送餐员姓名
@property(nonatomic ,strong) NSString *deliverName;

@end
