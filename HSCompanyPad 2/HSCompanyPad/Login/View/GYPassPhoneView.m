//
//  GYPassPhoneView.m
//  HSCompanyPad
//
//  Created by User on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYPassPhoneView.h"

@interface GYPassPhoneView()

@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;

@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@end

@implementation GYPassPhoneView

-(void)awakeFromNib{

    self.wrongCodeLabel.hidden=YES;
    
    self.phoneBackView.backgroundColor =[UIColor clearColor];
    
    self.codeBackView.backgroundColor =[UIColor clearColor];
    
    [self setDeaultBackLine:self.phoneBackView];
    
    [self setDeaultBackLine:self.codeBackView];
    
    self.codeBtn.layer.cornerRadius=6;
    self.codeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.codeBtn setBackgroundColor:kBlue2d89f0];

    [self.codeBtn addTarget:self action:@selector(pushCodeRequest:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _phoneImageView.customBorderType = UIViewCustomBorderTypeRight;
    _codeImageView.customBorderType =UIViewCustomBorderTypeRight;
    
}

#pragma mark -method
-(void)setDeaultBackLine:(UIView*)view{
    
    view.layer.borderWidth=1;
    
    view.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    view.backgroundColor =[UIColor clearColor];
    
    
}

-(void)pushCodeRequest:(UIButton*)button{

    if (self.phoneTF.text.length==0||self.codeTF.text==0) {
        
        return;
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectCodeBtnRequest:)]) {
        
        [self.delegate didSelectCodeBtnRequest:self.phoneTF.text];
        
    }
}
@end
