//
//  GYHDProtoBufHeader.m
//  HSConsumer
//
//  Created by shiang on 16/4/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDProtoBufHeader.h"

@implementation GYHDProtoBufHeader
- (instancetype)init
{
    if (self = [super init]) {
        _tag = 0x6873; //'hs'
        _version = 0x01; //'1'
        _cmdid = 0x00; // 命令
        _pkLength = 0x02; //
        _sessionid = [[NSDate date] timeIntervalSince1970];
        _destid = 0x00;
        _reversed = 0x00;
    }
    return self;
}

- (NSData*)DataWithProtobufData:(NSData*)protobufData
{
    uint16_t tag = htons(_tag); //'hs'
    uint8_t version = _version; //'1'
    uint16_t cmdid = htons(_cmdid); // 命令
    uint32_t pkLength = htonl(protobufData.length + 32); //
    uint32_t sessionid = htonl(_sessionid);
    uint64_t destid = htonll(_destid);
    uint32_t reversed = htonl(_version);
    int wei = 0;
    NSMutableData* data = [NSMutableData data];
    [data appendBytes:&tag length:2];
    [data appendBytes:&version length:1];
    [data appendBytes:&cmdid length:2];
    [data appendBytes:&pkLength length:4];
    [data appendBytes:&sessionid length:4];
    [data appendBytes:&destid length:8];
    [data appendBytes:&reversed length:4];
    [data appendBytes:&wei length:7];
    [data appendData:protobufData];
    return data;
}

- (instancetype)initWithData:(NSData*)data
{
    if (self = [super init]) {
        [data getBytes:&_tag range:NSMakeRange(0, 2)];
        [data getBytes:&_version range:NSMakeRange(2, 1)];
        [data getBytes:&_cmdid range:NSMakeRange(3, 2)];
        [data getBytes:&_pkLength range:NSMakeRange(5, 4)];
        [data getBytes:&_sessionid range:NSMakeRange(9, 4)];
        [data getBytes:&_destid range:NSMakeRange(13, 8)];
        [data getBytes:&_reversed range:NSMakeRange(21, 4)];

        _tag = ntohs(_tag);
        _cmdid = ntohs(_cmdid);
        _pkLength = ntohl(_pkLength);
        _sessionid = ntohl(_sessionid);
        _destid = ntohll(_destid);
        _reversed = ntohl(_reversed);
    }
    return self;
}

@end
