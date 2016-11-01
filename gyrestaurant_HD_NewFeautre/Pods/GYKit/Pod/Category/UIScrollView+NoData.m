//
//  UIScrollView+NoData.m
//  Applications
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 DZN Labs. All rights reserved.
//

#import "UIScrollView+NoData.h"
#import "UIColor+HEX.h"
#import <objc/runtime.h>

static char const * const kContent = "gy.hsxt.content";
static char const * const kBlock = "gy.hsxt.block";

@implementation UIScrollView (NoData)

-(void)setContent:(NSString *)content {
    objc_setAssociatedObject(self, kContent, content, OBJC_ASSOCIATION_COPY);
}

-(NSString *)content {
    return objc_getAssociatedObject(self, kContent);
}

-(void)setAction:(dispatch_noDataAction)action {
    objc_setAssociatedObject(self, kBlock, action, OBJC_ASSOCIATION_COPY);
}

-(dispatch_block_t)action {
    return objc_getAssociatedObject(self, kBlock);
}


- (void)noDataViewWithContext:(NSString*)content block:(dispatch_noDataAction)action
{
    self.action = action;
    self.content  = content;
    self.emptyDataSetDelegate = self;
    self.emptyDataSetSource = self;
    [self reloadEmptyDataSet];
  
}

#pragma mark - DZNEmptyDataSetSource
#pragma mark
- (NSAttributedString*)titleForEmptyDataSet:(UIScrollView*)scrollView
{
    NSString* text = self.content;//self.content;
    UIColor* textColor = [UIColor colorWithHex:@"545454"];
    ;
    UIFont* font = [UIFont boldSystemFontOfSize:17.0];
    NSMutableDictionary* attributes = [NSMutableDictionary new];
    if (!text) {
        return nil;
    }
    
    if (font)
        [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor)
        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//- (NSAttributedString*)descriptionForEmptyDataSet:(UIScrollView*)scrollView
//{
//    NSMutableDictionary* attributes = [NSMutableDictionary new];
//    
//    NSMutableParagraphStyle* paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//    NSString* text = @"content";
//    UIFont* font = [UIFont boldSystemFontOfSize:15.0];
//    UIColor* textColor = [UIColor colorWithHex:@"545454"];
//    if (!text) {
//        return nil;
//    }
//    if (font)
//        [attributes setObject:font forKey:NSFontAttributeName];
//    if (textColor)
//        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//    if (paragraph)
//        [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
//    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
//    return attributedString;
//}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_data"];
}

//- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
//{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
//    animation.duration = 0.25;
//    animation.cumulative = YES;
//    animation.repeatCount = MAXFLOAT;
//    
//    return animation;
//}



- (NSAttributedString*)buttonTitleForEmptyDataSet:(UIScrollView*)scrollView forState:(UIControlState)state
{
    NSString* text = @"重新加载";
    UIFont* font = [UIFont boldSystemFontOfSize:16.0];
    UIColor* textColor = [UIColor colorWithHex:(state == UIControlStateNormal) ? @"05adff" : @"6bceff"];
    if (!text) {
        return nil;
    }
    
    NSMutableDictionary* attributes = [NSMutableDictionary new];
    if (font)
        [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor)
        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}



#pragma mark - DZNEmptyDataSetDelegate
#pragma mark

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView*)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView*)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView*)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView*)scrollView didTapView:(UIView*)view
{
    if (self.action) {
         self.action();
    }
   
}

- (void)emptyDataSet:(UIScrollView*)scrollView didTapButton:(UIButton*)button
{
    
    if (self.action) {
        self.action();
    }
}
@end
