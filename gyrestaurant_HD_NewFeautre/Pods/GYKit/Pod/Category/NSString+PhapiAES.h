//
//  NSString+PhapiAES.h
//  PhaiAES
//
//  Created by zhangqy on 16/4/6.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PhapiAES)

- (NSString *)encodeWithKey:(NSString *)key;

- (NSString *)decodeWithKey:(NSString *)key;

@end
