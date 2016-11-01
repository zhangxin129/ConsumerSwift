//
//  GYHDStream.h
//  HSConsumer
//
//  Created by shiang on 16/4/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDStream : NSObject

@property (nonatomic,copy) NSString *hostName;//IP
@property (nonatomic, assign) UInt16 hostPort;//端口
@property (nonatomic, assign) SInt32 errorCode;

@end
