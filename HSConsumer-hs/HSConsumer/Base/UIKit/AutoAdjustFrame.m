//
//  AutoAdjustFrame.m
//  HSConsumer
//
//  Created by Yejg on 16/5/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#import "AutoAdjustFrame.h"
#import <UIKit/UIKit.h>
@implementation AutoAdjustFrame

+ (CGFloat)heightForString:(NSString*)str font:(NSInteger)font
{
    NSDictionary* dic = @{ NSFontAttributeName : [UIFont systemFontOfSize:font] };
    CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20 - 25, 100000)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:dic
                                    context:nil];
    return rect.size.height;
}

+ (CGFloat)heightForString:(NSString*)str width:(CGFloat)width font:(NSInteger)font
{
    NSDictionary* dic = @{ NSFontAttributeName : [UIFont systemFontOfSize:font] };
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 100000)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:dic
                                    context:nil];
    return rect.size.height;
}

+ (CGFloat)widthForString:(NSString*)str font:(NSInteger)font
{

    NSDictionary* dic = @{ NSFontAttributeName : [UIFont systemFontOfSize:font] };
    CGRect rect = [str boundingRectWithSize:CGSizeMake(100000, 21)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:dic
                                    context:nil];
    return rect.size.width;
}

@end
