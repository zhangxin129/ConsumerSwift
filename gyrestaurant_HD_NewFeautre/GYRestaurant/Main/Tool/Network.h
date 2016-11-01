//
//  Network.h
//  GYCompany
//
//  Created by cook on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFSecurityPolicy.h"
#import "AFHTTPSessionManager.h"


@class AFHTTPSessionManager;

typedef void (^SuccessValueBlock) (id returnValue);
typedef void (^FailureBlock) (NSError * error);

@interface Network : AFHTTPSessionManager



#pragma mark POST请求
+ (void)POST: (NSString *) requestURLString

                    parameter: (NSDictionary *) parameter

             success: (SuccessValueBlock) block

                 failure: (FailureBlock) failureBlock;


#pragma GET请求
+ (void) GET: (NSString *) requestURLString
             parameter: (NSDictionary *) parameter
      success: (SuccessValueBlock) block
          failure: (FailureBlock) failureBlock;


#pragma --mark DELETE请求方式
+ (void) DELETE: (NSString *) requestURLString

                parameter: (NSDictionary *) parameter

         success: (SuccessValueBlock) block


             failure: (FailureBlock) failureBlock;
#pragma --mark PUT请求方式

+ (void) PUT: (NSString *) requestURLString

             parameter: (NSDictionary *) parameter

      success: (SuccessValueBlock) block

          failure: (FailureBlock) failureBlock;




@end
