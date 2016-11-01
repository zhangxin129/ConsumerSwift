//
//  UILabel+Category.m
//  HSCompanyPad
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

-(void)initWithText:(NSString *)text TextColor:(UIColor *)textColor Font:(UIFont *)font TextAlignment:(NSInteger)textAlignment{

    self.text = text;
    self.textColor = textColor;
    self.font = font;
    self.textAlignment = textAlignment;
}

@end
