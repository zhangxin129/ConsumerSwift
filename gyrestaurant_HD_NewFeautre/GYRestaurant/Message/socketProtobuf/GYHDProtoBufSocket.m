//
//  GYHDProtoBufSocket.m
//  HSConsumer
//
//  Created by shiang on 16/4/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDProtoBufSocket.h"
#import "GCDAsyncSocket.h"
#import "GYHDStream.h"
@interface GYHDProtoBufSocket ()<GCDAsyncSocketDelegate>
/**登录服务器参数*/
@property(nonatomic, strong)GYHDStream      *stream;
@property(nonatomic,strong)GCDAsyncSocket   *hdSocket;
@end

@implementation GYHDProtoBufSocket
/**设置*/
- (void)setloginStream:(GYHDStream *)loginStream {
self.stream = loginStream;
self.hdSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}
/**登录*/
- (void)Login {
[self.hdSocket connectToHost:self.stream.hostName onPort:self.stream.hostPort error:nil];
}
//判断是否连接
-(BOOL)isConnect{

    return [self.hdSocket connectToHost:self.stream.hostName onPort:self.stream.hostPort error:nil];
//     return [self.hdSocket isConnected];
    
}
/**登出*/
- (void)Logout {

[self.hdSocket disconnect];
}
- (void)sendMessageWithData:(NSData *)data {
[self.hdSocket writeData:data withTimeout:-1 tag:110];

}

#pragma  mark- GCDAsyncSocket代理方法
- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(uint16_t)port {
DDLogCInfo(@"互动 连接成功---%@----%d",host,port);

if ([self.delegate respondsToSelector:@selector(protoBufStreamDidConnect:)]) {
    [self.delegate protoBufStreamDidConnect:self.stream];
}
}

- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err {
DDLogCInfo(@"互动 连接失败 %@", err);
    
//    [self Logout];
    
if ([self.delegate respondsToSelector:@selector(protoBufStreamDidDisconnect:withError:)]) {
    [self.delegate protoBufStreamDidDisconnect:self.stream withError:err];
}
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
if ([data isKindOfClass:[NSNull class]]) return;
__block  NSData *recvData = [NSData dataWithData:data];

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    long long recvLength = recvData.length;
    const char *bytes = [recvData bytes];
    for (int i = 0; i < recvLength; i++) {
        if ( (bytes[i] == 0x00 && bytes[i+1] == 0x00 && bytes[i+2] == 0x01) ||
            (bytes[i] == 0x68 && bytes[i+1] == 0x73 && bytes[i+2] == 0x01)  ) {
        int pkLen = 0;
[recvData getBytes:&pkLen range:NSMakeRange(5, 4)];
        pkLen = ntohl(pkLen);
        if (i+pkLen == recvData.length) {
            NSData *tData = [recvData subdataWithRange:NSMakeRange(i, pkLen)];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(protoBufStream:didReceiveMessage:)]) {
                    [self.delegate protoBufStream:self.stream didReceiveMessage:tData];
                }
            });
            break;
        } else if (i+pkLen < recvData.length) {
            if ( (bytes[i+pkLen] == 0x00 && bytes[i+pkLen+1] == 0x00 && bytes[i+pkLen+2] == 0x01) ||
                (bytes[i+pkLen] == 0x68 && bytes[i+pkLen+1] == 0x73 && bytes[i+pkLen+2] == 0x01)) {
                NSData *tData = [recvData subdataWithRange:NSMakeRange(i, pkLen)];
                if (pkLen > 32) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self.delegate respondsToSelector:@selector(protoBufStream:didReceiveMessage:)]) {
                            [self.delegate protoBufStream:self.stream didReceiveMessage:tData];
                        }
                    });
                    i = i+pkLen-1;
                }
            }
        }
    }
    }
});
[self.hdSocket readDataWithTimeout:-1 tag:tag];


}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
//    if ([self.delegate respondsToSelector:@selector(protoBufStream:didReceiveMessage:)]) {
//        [self.delegate protoBufStream:self.stream didReceiveMessage:nil];
//    }
[self.hdSocket readDataWithTimeout:-1 tag:tag];
}
//- (void)sock
@end
