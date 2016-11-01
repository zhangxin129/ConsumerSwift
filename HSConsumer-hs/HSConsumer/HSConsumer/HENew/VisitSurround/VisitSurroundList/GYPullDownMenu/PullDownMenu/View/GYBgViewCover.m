//
//  GYBgViewCover.m
//  GYHEPullDown
//
//  Created by kuser on 16/9/23.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import "GYBgViewCover.h"

@implementation GYBgViewCover

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_clickCover) {
        _clickCover();
    }
}

@end
