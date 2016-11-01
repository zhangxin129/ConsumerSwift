//
//  SCustomID.h
//  GYHDSDK
//
//  Created by Yejg on 16/8/10.
//  Copyright © 2016年 jianglincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCustomID : NSObject

@property (nonatomic, assign) unsigned long cre_time;   // 创建时间
@property (nonatomic, assign) unsigned long src_ip;		// 来源IP
@property (nonatomic, assign) unsigned short src_port;	// 来源端口
@property (nonatomic, assign) unsigned long seq;		// 自增序


+ (SCustomID*)modelWithCre_time:(unsigned long)cre_time
                         src_ip:(unsigned long)src_ip
                       src_port:(unsigned short)src_port
                            seq:(unsigned long)seq;

@end
