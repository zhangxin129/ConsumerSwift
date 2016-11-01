//
//  DUKPT_2009_CBC.h
//  DUKPT_2009_CBC_OC
//
//  Created by zengqingfu on 15/3/12.
//  Copyright (c) 2015年 zengqingfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DUKPT_2009_CBC : NSObject

+ (NSData*)GenerateIPEK:(NSData*)ksn bdk:(NSData*)bdk;
+ (NSData*)GetDUKPTKey:(NSData*)ksn ipek:(NSData*)ipek;
+ (NSData*)GetDataKeyVariant:(NSData*)ksn ipek:(NSData*)ipek;
+ (NSData*)GetPinKeyVariant:(NSData*)ksn ipek:(NSData*)ipek;
+ (NSData*)GetMacKeyVariant:(NSData*)ksn ipek:(NSData*)ipek;
+ (NSData*)GetDataKey:(NSData*)ksn ipek:(NSData*)ipek;

@end
