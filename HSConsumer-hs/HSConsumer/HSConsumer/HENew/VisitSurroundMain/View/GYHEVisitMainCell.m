//
//  GYHEVisitMainCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEVisitMainCell.h"
#import "YYKit.h"

@interface GYHEVisitMainCell()



@end

@implementation GYHEVisitMainCell

-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

   
    self.overlayView = [[UIView alloc] init];
    self.overlayView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.overlayView];
    
    self.typeImageView = [[UIImageView alloc] init];
    self.typeImageView.layer.cornerRadius = 25;
    self.typeImageView.clipsToBounds = YES;
    [self.overlayView addSubview:self.typeImageView];
    
    UIFont *font = [UIFont systemFontOfSize:12];
    UIColor *color = UIColorFromRGB(0x666666);
    
    self.titlelabel = [[UILabel alloc] init];
    self.titlelabel.textAlignment = NSTextAlignmentCenter;
    self.titlelabel.font = font;
    self.titlelabel.textColor = color;
    [self.overlayView addSubview:self.titlelabel];
    
}

-(void)layoutSubviews {

    [super layoutSubviews];
    
    self.overlayView.frame = self.bounds;
    self.typeImageView.frame = CGRectMake(0, 15, 50, 50);
    self.titlelabel.frame = CGRectMake(0, self.typeImageView.bottom + 7, self.typeImageView.width, 12);
}



@end
