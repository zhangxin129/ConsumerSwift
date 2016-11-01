//
//  GYHDProtoBufHeader.h
//  GYHDSDK
//
//  Created by Yejg on 16/8/8.
//  Copyright © 2016年 jianglincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYHDStream;
@class SCustomID;
@interface GYHDProtoBufHeader : NSObject

@property (nonatomic, assign) unsigned char tag0; // 协议标识，固定值0x48，“H”的ASCII码
@property (nonatomic, assign) unsigned char tag1; // 协议标识，固定值0x58，“X”的ASCII码
@property (nonatomic, assign) unsigned char version; // 版本号
@property (nonatomic, strong) SCustomID *transact_id; // 事务ID，直接返回服务器的东西就好
@property (nonatomic, assign) unsigned long ec_type;	// 加密与压缩类型
@property (nonatomic, assign) unsigned short cmd;		// 事务命令字
@property (nonatomic, assign) unsigned long size;	// 包长度

+ (instancetype)headerWithGYHDStream:(GYHDStream*)stream;

/**拼接单纯的包头，不包含包体*/
- (NSData*)dataOfHeader;

/**拼接数据*/
- (NSData*)dataWithProtobufData:(NSData*)protobufData;
/**解包头*/
- (instancetype)initWithData:(NSData*)data;

@end
