//
//  GYHDStream.h
//  HSConsumer
//
//  Created by Yejg on 16/8/8.
//  Copyright © 2016年 jianglincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDStream : NSObject

@property (nonatomic,copy) NSString *hostName;
@property (nonatomic, assign) UInt16 hostPort;
@property (nonatomic, assign) SInt32 errorCode;

@end
