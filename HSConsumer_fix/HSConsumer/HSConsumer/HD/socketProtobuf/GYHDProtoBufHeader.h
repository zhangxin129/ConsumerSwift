//
//  GYHDProtoBufHeader.h
//  HSConsumer
//
//  Created by shiang on 16/4/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDProtoBufHeader : NSObject

@property (nonatomic, assign) uint16_t tag; //'hs'
@property (nonatomic, assign) uint8_t version; //'1'
@property (nonatomic, assign) uint16_t cmdid; // 命令
@property (nonatomic, assign) uint32_t pkLength; //
@property (nonatomic, assign) uint32_t sessionid;
@property (nonatomic, assign) uint64_t destid;
@property (nonatomic, assign) uint32_t reversed;
/**拼接数据*/
- (NSData*)DataWithProtobufData:(NSData*)protobufData;
/**解包头*/
- (instancetype)initWithData:(NSData*)data;
@end
