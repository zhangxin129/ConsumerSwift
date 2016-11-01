//
//  GYSuccessView.m
//  HSCompanyPad
//
//  Created by User on 16/8/17.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSuccessView.h"

@interface GYSuccessView ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end
@implementation GYSuccessView


-(void)awakeFromNib{

    _backView.backgroundColor=[UIColor clearColor];
    
    
    
}


@end
