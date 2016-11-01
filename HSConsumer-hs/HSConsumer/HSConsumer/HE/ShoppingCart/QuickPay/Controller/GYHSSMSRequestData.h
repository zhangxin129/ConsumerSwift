//
//  GYHSSMSRequestData.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, GYRequestMethod) {
    GYRequestMethodGET = 0,
    GYRequestMethodPOST,
};

typedef void (^GYHSSMSRequestDataBlock)(BOOL result, NSDictionary* serverDic);
@interface GYHSSMSRequestData : NSObject

- (void)clearTimer;

// 发生验证码请求
- (void)sendSMSCode:(NSString*)url
           paramDic:(NSDictionary*)paramDic
             button:(UIButton*)button
            timeOut:(NSInteger)timeout
      requestMethod:(GYRequestMethod)requestMethod
        resultBLock:(GYHSSMSRequestDataBlock)resultBlock;

@end
