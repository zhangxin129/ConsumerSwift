//
//  GYPassResetView.m
//  HSCompanyPad
//
//  Created by User on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYPassResetView.h"
#import <GYKit/UIView+Extension.h>

@implementation GYPassResetView{


    __weak IBOutlet UIImageView *passImageView;
    
    
    __weak IBOutlet UIImageView *reSetImageView;
}

-(void)awakeFromNib{

    passImageView.customBorderType = UIViewCustomBorderTypeRight;
    
    reSetImageView.customBorderType = UIViewCustomBorderTypeRight;
    
    [self setDeaultBackLine:self.passBackView];
    [self setDeaultBackLine:self.passResetBackView];
    
}

-(void)setDeaultBackLine:(UIView*)view{
    
    view.layer.borderWidth=1;
    
    view.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    view.backgroundColor =[UIColor clearColor];
    
}

@end
