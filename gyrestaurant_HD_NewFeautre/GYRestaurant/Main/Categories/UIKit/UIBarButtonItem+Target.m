//
//  UIBarButtonItem+Target.m
//  GYCompany
//
//  Created by cook on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "UIBarButtonItem+Target.h"
#import "UIView+Extension.h"
#import "NSString+Size.h"
@interface NSString (barButtonExtension)

/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;


@end



@implementation NSString (barButtonExtension)

/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}
@end
@implementation UIBarButtonItem (Target)

+ (instancetype)itemWithTarget: (id) target  action: (SEL)action normalImageName: (NSString *)normalImageName highlightedImageName:(NSString *)highlightImageName
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.size =button.currentBackgroundImage.size;
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
    
}


+ (instancetype)itemWithTarget: (id) target  action: (SEL)action normalTitle: (NSString *)normalTitle highlightedTitle:(NSString *)highlightTitle
{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:normalTitle forState:UIControlStateNormal];
    [button setTitle:highlightTitle forState:UIControlStateHighlighted];
    NSComparisonResult result = [normalTitle compare:highlightTitle options:NSLiteralSearch];
    
    CGSize titleSize ;
    titleSize = result == NSOrderedDescending ? [normalTitle sizeWithFont:[UIFont systemFontOfSize:14] constrainedToHeight:30] : [highlightTitle sizeWithFont:[UIFont systemFontOfSize:14] constrainedToHeight:30];

    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.size = titleSize;
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];

}
@end

