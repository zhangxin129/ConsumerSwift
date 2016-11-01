//
//  GYScrollView.m
//  GYCompany
//
//  Created by cook on 15/9/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYScrollView.h"

@implementation GYScrollView


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    [super touchesBegan:touches withEvent:event];
    if ( !self.dragging )
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    
    [self endEditing:YES];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if ( !self.dragging )
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [self endEditing:YES];
    
}

@end
