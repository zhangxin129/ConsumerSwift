//
//  GYPassMailView.m
//  HSCompanyPad
//
//  Created by User on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYPassMailView.h"

@interface GYPassMailView ()

@property (weak, nonatomic) IBOutlet UIView *maillBackView;
@property (weak, nonatomic) IBOutlet UIImageView *mailImageView;

@end

@implementation GYPassMailView


-(void)awakeFromNib{

    self.maillBackView.backgroundColor =[UIColor clearColor];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _mailImageView.customBorderType = UIViewCustomBorderTypeRight;
    
    [self setDeaultBackLine:self.maillBackView];
    
}

-(void)setDeaultBackLine:(UIView*)view{
    
    view.layer.borderWidth=1;
    
    view.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    view.backgroundColor =[UIColor clearColor];
    
}

@end
