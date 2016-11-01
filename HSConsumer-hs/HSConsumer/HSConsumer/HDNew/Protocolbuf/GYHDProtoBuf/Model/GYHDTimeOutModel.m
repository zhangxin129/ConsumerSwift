//
//  GYHDTimeOutModel.m
//  HSCompanyPad
//
//  Created by Yejg on 16/10/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDTimeOutModel.h"

@implementation GYHDTimeOutModel

- (instancetype)initWithMsguid:(NSString *)msguid {
    
    if (self = [super init]) {
        self.strMsguid = msguid;
        self.counter = 0;
    }
    return self;
}

@end
