//
//  GYHDStream.h
//  HSConsumer
//
//  Created by shiang on 16/4/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDStream : NSObject
@property (readwrite, copy) NSString* hostName;
@property (readwrite, assign) UInt16 hostPort;
@end
