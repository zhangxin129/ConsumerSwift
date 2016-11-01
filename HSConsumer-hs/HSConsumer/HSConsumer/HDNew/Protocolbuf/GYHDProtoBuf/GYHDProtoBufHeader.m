//
//  GYHDProtoBufHeader.m
//  GYHDSDK
//
//  Created by Yejg on 16/8/8.
//  Copyright © 2016年 jianglincen. All rights reserved.
//

#import "GYHDProtoBufHeader.h"
#import "ImHxcommon.pb.h"
#import "SCustomID.h"
#import "GYHDStream.h"

@implementation GYHDProtoBufHeader

- (instancetype)init
{
    if (self = [super init]) {
        self.tag0 = 'H'; //'协议标识'固定值0x48，“H”的ASCII码
        self.tag1 = 'X'; //'协议标识'固定值0x58，“X”的ASCII码
        self.version = 0x0004; //版本号
        
        self.transact_id = [[SCustomID alloc]init];
        
        self.ec_type = 0x0200; //加密与压缩类型
        self.cmd = 8193;
        self.size = 0x0000;//消息大小
    }
    return self;
}

+ (instancetype)headerWithGYHDStream:(GYHDStream *)stream
{
    GYHDProtoBufHeader *header = [[GYHDProtoBufHeader alloc]init];
    
    NSDate *date = [NSDate date];
    header.transact_id = [SCustomID modelWithCre_time:[date timeIntervalSince1970]
                                               src_ip:192168229139
                                             src_port:stream.hostPort
                                                  seq:0]; // 事务ID
    return header;
}

- (NSData *)dataOfHeader
{
    unsigned char tag0 = self.tag0; //'H'
    unsigned char tag1 = self.tag1; //'X'
    unsigned char version = self.version;
    
    unsigned long cre_time = htonl(self.transact_id.cre_time);   // 创建时间
    unsigned long src_ip = htonl(self.transact_id.src_ip);		// 来源IP
    unsigned short src_port = htons(self.transact_id.src_port);	// 来源端口
    unsigned long seq = htonl(self.transact_id.seq);		// 自增序
    
    unsigned long ec_type = htonl(self.ec_type); //
    unsigned short cmd = htons(self.cmd); //
    unsigned long size = htonl(self.size);
    
    NSMutableData* data = [NSMutableData data];
    
    [data appendBytes:&tag0 length:1];
    [data appendBytes:&tag1 length:1];
    [data appendBytes:&version length:1];
    [data appendBytes:&cre_time length:4];
    [data appendBytes:&src_ip length:4];
    [data appendBytes:&src_port length:2];
    [data appendBytes:&seq length:4];
    [data appendBytes:&ec_type length:4];
    [data appendBytes:&cmd length:2];
    [data appendBytes:&size length:4];
    return data;
}

- (NSData*)dataWithProtobufData:(NSData*)protobufData
{
    
    unsigned char tag0 = self.tag0; //'H'
    unsigned char tag1 = self.tag1; //'X'
    unsigned char version = self.version;
    
    unsigned long cre_time = htonl(self.transact_id.cre_time);   // 创建时间
    unsigned long src_ip = htonl(self.transact_id.src_ip);		// 来源IP
    unsigned short src_port = htons(self.transact_id.src_port);	// 来源端口
    unsigned long seq = htonl(self.transact_id.seq);		// 自增序
    
    unsigned long ec_type = htonl(self.ec_type); //
    unsigned short cmd = htons(self.cmd); //
    unsigned long size = htonl(protobufData.length);
    
    NSMutableData* data = [NSMutableData data];
    
    [data appendBytes:&tag0 length:1];
    [data appendBytes:&tag1 length:1];
    [data appendBytes:&version length:1];
    [data appendBytes:&cre_time length:4];
    [data appendBytes:&src_ip length:4];
    [data appendBytes:&src_port length:2];
    [data appendBytes:&seq length:4];
    [data appendBytes:&ec_type length:4];
    [data appendBytes:&cmd length:2];
    [data appendBytes:&size length:4];
    [data appendData:protobufData];
    return data;
}

- (instancetype)initWithData:(NSData*)data
{
    if (self = [super init]) {
        [data getBytes:&_tag0 range:NSMakeRange(0, 1)];
        [data getBytes:&_tag1 range:NSMakeRange(1, 1)];
        [data getBytes:&_version range:NSMakeRange(2, 1)];
        
        unsigned long cre_time = 0;   // 创建时间
        unsigned long src_ip = 0;		// 来源IP
        unsigned short src_port = 0;	// 来源端口
        unsigned long seq = 0;		// 自增序
        
        [data getBytes:&cre_time range:NSMakeRange(3, 4)];
        [data getBytes:&src_ip range:NSMakeRange(7, 4)];
        [data getBytes:&src_port range:NSMakeRange(11, 2)];
        [data getBytes:&seq range:NSMakeRange(13, 4)];
        
        unsigned long ec_type = 0;		// 来源IP
        unsigned short cmd = 0;		// 与系统关键字冲突
        unsigned long size = 0;	// 来源端口
        [data getBytes:&ec_type range:NSMakeRange(17, 4)];
        [data getBytes:&cmd range:NSMakeRange(21, 2)];
        [data getBytes:&size range:NSMakeRange(23, 4)];
        
        cre_time = ntohl(cre_time);
        src_ip = ntohl(src_ip);
        src_port = ntohs(src_port);
        seq = ntohl(seq);
        
        self.transact_id = [SCustomID modelWithCre_time:cre_time
                                                 src_ip:src_ip
                                               src_port:src_port
                                                    seq:seq];
        
        self.ec_type = ntohl(ec_type);
        self.cmd = ntohs(cmd);
        self.size = ntohl(size);
    }
    return self;
}

@end
