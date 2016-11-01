//
//  AutoAdjustFrame.h
//  HSConsumer
//
//  Created by Yejg on 16/5/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AutoAdjustFrame : NSObject

+ (CGFloat)heightForString:(NSString*)str font:(NSInteger)font;
+ (CGFloat)widthForString:(NSString*)str font:(NSInteger)font;
+ (CGFloat)heightForString:(NSString*)str width:(CGFloat)width font:(NSInteger)font;

@end
