//
//  GYHDCompanyDetailCollectionReusableView.m
//  GYRestaurant
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCompanyDetailCollectionReusableView.h"

@implementation GYHDCompanyDetailCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.backgroundColor=[UIColor whiteColor];
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        
    }
    return self;
}
@end
