//
//  GYCardReaderModel.m
//  HSCompanyPad
//
//  Created by sqm on 16/9/7.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYCardReaderModel.h"

@implementation GYCardReaderModel
- (instancetype)init
{
    if (self = [super init]) {
        _isConnected = NO; //默认未连接；
    }
    return self;
}

@end
