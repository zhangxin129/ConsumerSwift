//
//  GYTf.m
//  HSCompanyPad
//
//  Created by cook on 16/9/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYTextField.h"

@implementation GYTextField


- (nullable UITextPosition*)closestPositionToPoint:(CGPoint)point
{
   
    return self.endOfDocument;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
//    if ([UIMenuController sharedMenuController]) {
//        [UIMenuController sharedMenuController].menuVisible = NO;
//    }
//    return YES;
    return NO;
    
}

//- (CGRect)clearButtonRectForBounds:(CGRect)bounds
//{
//    if (self.rightView) {
//         return CGRectMake(200, 0, 300, 45);
//    }
//    return [super clearButtonRectForBounds:bounds];
//    
//
//}
@end
