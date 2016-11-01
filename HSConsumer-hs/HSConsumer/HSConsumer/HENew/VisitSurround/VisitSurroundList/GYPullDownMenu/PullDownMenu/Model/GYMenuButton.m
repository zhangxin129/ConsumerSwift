//
//  GYMenuButton.m
//  GYHEPullDown
//
//  Created by kuser on 16/9/23.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import "GYMenuButton.h"

@implementation GYMenuButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.imageView.x < self.titleLabel.x) {
        self.titleLabel.x = self.imageView.x;
        self.imageView.x = self.titleLabel.maxX + 5;
    }
}

@end
