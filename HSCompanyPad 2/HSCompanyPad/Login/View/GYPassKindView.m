//
//  GYPassKindView.m
//  HSCompanyPad
//
//  Created by User on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYPassKindView.h"
#import <GYKit/UIView+Extension.h>

@interface GYPassKindView()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *mailTF;

@property (weak, nonatomic) IBOutlet UITextField *questionTF;

@end

@implementation GYPassKindView

-(void)awakeFromNib{

    _phoneImageView.customBorderType = UIViewCustomBorderTypeRight;
    
    _mailImageView.customBorderType = UIViewCustomBorderTypeRight;
    
    _questionImageView.customBorderType = UIViewCustomBorderTypeRight;
    
    [self setDeaultBackLine:_phoneBackView];
    
    [self setDeaultBackLine:_mailBackView];
    
    [self setDeaultBackLine:_questionBackView];
    
    self.selectType = kForgetPassType_Phone;
}

- (IBAction)phoneBtnAction:(id)sender {
    
    _selectType = kForgetPassType_Phone;
    
    [self.phoneSelectBtn setImage:kLoadPng(@"gy_radio_select") forState:UIControlStateNormal];
    [self.mailBtn setImage:kLoadPng(@"gy_radio_unselect") forState:UIControlStateNormal];
    [self.questionBtn setImage:kLoadPng(@"gy_radio_unselect") forState:UIControlStateNormal];
    
    [self.phoneImageView setImage:kLoadPng(@"gy_phone_select")];
    [self.mailImageView setImage:kLoadPng(@"gy_mail_unselect")];
    [self.questionImageView setImage:kLoadPng(@"gy_security_unselect")];

    [self didSelectTextField:self.phoneTF];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectPassKind:)]) {
        
        [self.delegate didSelectPassKind:kForgetPassType_Phone];
        
    }
    
}

- (IBAction)mailBtnAction:(id)sender {
    
    _selectType = kForgetPassType_Mail;
    
    [self.phoneSelectBtn setImage:kLoadPng(@"gy_radio_unselect") forState:UIControlStateNormal];
    [self.mailBtn setImage:kLoadPng(@"gy_radio_select") forState:UIControlStateNormal];
    [self.questionBtn setImage:kLoadPng(@"gy_radio_unselect") forState:UIControlStateNormal];

    [self.phoneImageView setImage:kLoadPng(@"gy_phone_unselect")];
    [self.mailImageView setImage:kLoadPng(@"gy_mail_select")];
    [self.questionImageView setImage:kLoadPng(@"gy_security_unselect")];
    
    [self didSelectTextField:self.mailTF];

    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectPassKind:)]) {
        
        [self.delegate didSelectPassKind:kForgetPassType_Mail];
        
    }
}

- (IBAction)questionBtnAction:(id)sender {
    
    _selectType = kForgetPassType_Question;
    
    [self.phoneSelectBtn setImage:kLoadPng(@"gy_radio_unselect") forState:UIControlStateNormal];
    [self.mailBtn setImage:kLoadPng(@"gy_radio_unselect") forState:UIControlStateNormal];
    [self.questionBtn setImage:kLoadPng(@"gy_radio_select") forState:UIControlStateNormal];

    [self.phoneImageView setImage:kLoadPng(@"gy_phone_unselect")];
    [self.mailImageView setImage:kLoadPng(@"gy_mail_unselect")];
    [self.questionImageView setImage:kLoadPng(@"gy_security_select")];
    
    [self didSelectTextField:self.questionTF];

    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectPassKind:)]) {
        
        [self.delegate didSelectPassKind:kForgetPassType_Question];
        
    }
}

-(void)didSelectViewLayer:(UIView*)view{

}

-(void)didDeslectViewLayer:(UIView*)view{
    
}

-(void)setDeaultBackLine:(UIView*)view{

    view.layer.borderWidth=1;
    
    view.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    view.backgroundColor =[UIColor clearColor];
    
}

-(void)didSelectTextField:(UITextField*)tf{

    NSArray *tfArray =@[_phoneTF,_mailTF,_questionTF];
    
    for (UITextField *textfield in tfArray) {
        
        if ([textfield isEqual:tf]) {
        
            textfield.textColor = kBlue0A59C1;
        }
        else{
            textfield.textColor = [UIColor lightGrayColor];
        }
    }
    
}
@end
