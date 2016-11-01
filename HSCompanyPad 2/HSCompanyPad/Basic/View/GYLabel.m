//
//  GYLabel.m
//  HSCompanyPad
//
//  Created by sqm on 16/9/26.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYLabel.h"
#import "GYHSEdgeLabel.h"
#import "GYHSPublicMethod.h"

@interface GYLabel()
@property (nonatomic, weak) UILabel *label;
@end

@implementation GYLabel



- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
 
    UIViewController * controller = [GYHSPublicMethod viewControllerWithView:self];
    CGFloat edgeFloat = 8;
    GYHSEdgeLabel * label = [[GYHSEdgeLabel alloc]initWithFrame:CGRectZero];
    label.text = self.fullText;
    label.edgeInsets = UIEdgeInsetsMake(edgeFloat, edgeFloat, edgeFloat, edgeFloat);
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.backgroundColor = kGray777777;
    label.layer.cornerRadius = 6;
    label.clipsToBounds = YES;
    self.label = label;
    label.textColor = kWhiteFFFFFF;
    CGSize labSize = [self.fullText boundingRectWithSize:CGSizeMake(self.width  * 0.5 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font, NSFontAttributeName, nil] context:nil].size;
    [label sizeToFit];
    labSize.width = self.width  * 0.8;//宽度保存不变
    label.size = labSize;
    [controller.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    CGRect rect = [self convertRect:self.bounds toView:controller.view];
    label.centerX = CGRectGetMidX(rect);
    if ((CGRectGetMinY(rect) + labSize.height) > kScreenHeight) {
        label.centerY = kScreenHeight - kNavigationHeight - labSize.height/2.0 - 20;
    } else{
        label.centerY = CGRectGetMidY(rect);
    }
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.label removeFromSuperview];

}
@end
