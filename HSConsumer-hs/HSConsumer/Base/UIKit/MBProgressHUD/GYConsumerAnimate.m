//
//  GYConsumerAnimate.m
//  HSConsumer
//
//  Created by wangfd on 16/10/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYConsumerAnimate.h"
#import "GYGIFHUD.h"

@implementation GYConsumerAnimate

- (void)startAnimating
{
    DDLogDebug(@"GYConsumerAnimate %s", __FUNCTION__);
    [GYGIFHUD show];
}

- (void)stopAnimating
{
    DDLogDebug(@"GYConsumerAnimate %s", __FUNCTION__);
    [GYGIFHUD dismiss];
}
@end
