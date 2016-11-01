//
//  SCustomID.m
//  GYHDSDK
//
//  Created by Yejg on 16/8/10.
//  Copyright © 2016年 jianglincen. All rights reserved.
//

#import "SCustomID.h"

@implementation SCustomID

- (instancetype)initWithCre_time:(unsigned long)cre_time
                          src_ip:(unsigned long)src_ip
                        src_port:(unsigned short)src_port
                             seq:(unsigned long)seq
{
    if (self = [super init]) {
        self.cre_time = cre_time;
        self.src_ip = src_ip;
        self.src_port = src_port;
        self.seq = seq;
    }
    return self;
}

+ (SCustomID *)modelWithCre_time:(unsigned long)cre_time
                          src_ip:(unsigned long)src_ip
                        src_port:(unsigned short)src_port
                             seq:(unsigned long)seq
{
    SCustomID *model = [[SCustomID alloc]initWithCre_time:cre_time
                                                   src_ip:src_ip
                                                 src_port:src_port
                                                      seq:seq];
    return model;
}

@end
