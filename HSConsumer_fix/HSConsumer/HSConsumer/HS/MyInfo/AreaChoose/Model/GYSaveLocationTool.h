//
//  GYSaveLocationTool.h
//  HSConsumer
//
//  Created by Apple03 on 15/11/5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^bResult)(BOOL result);

@interface GYSaveLocationTool : NSObject
+ (void)saveRequest:(NSString*)address result:(bResult)result;

@end
