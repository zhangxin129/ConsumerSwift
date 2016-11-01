//
//  GYHSExchangeButton.m
//  HSCompanyPad
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSExchangeButton.h"

@implementation GYHSExchangeButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = contentRect.origin.x + (contentRect.size.width- kDeviceProportion(90))/2.0;
    CGFloat imageY = contentRect.origin.y + (contentRect.size.height- kDeviceProportion(135))/2.0;
    CGFloat width = kDeviceProportion(90);
    CGFloat height = kDeviceProportion(90);
    ;
    return CGRectMake(imageX, imageY, width, height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = contentRect.origin.x;
    CGFloat imageY = contentRect.origin.y + (contentRect.size.height- kDeviceProportion(135))/2.0  + contentRect.size.width;
    CGFloat width = contentRect.size.width;
    CGFloat height = 20;
    return CGRectMake(imageX, imageY, width, height);
}

@end
