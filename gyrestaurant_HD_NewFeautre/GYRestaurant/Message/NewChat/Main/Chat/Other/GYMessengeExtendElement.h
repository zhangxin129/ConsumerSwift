//
//  GYExtendElement.h
//  HSConsumer
//
//  Created by shiang on 15/10/8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "DDXMLElement.h"

@interface GYMessengeExtendElement: DDXMLElement



+(id)GYExtendElementWithID:(NSString *)id;


+(id)GYExtendElementWithElementId:(NSString *)elementID withSender:(NSString *)sender;
@end
