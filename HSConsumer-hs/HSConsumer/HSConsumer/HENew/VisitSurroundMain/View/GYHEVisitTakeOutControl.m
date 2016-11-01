//
//  GYHEVisitTakeOutControl.m
//  HSConsumer
//
//  Created by lizp on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEVisitTakeOutControl.h"
#import "YYKit.h"
#import "GYHEVisitTakeOutControl.h"

@implementation GYHEVisitTakeOutControl

-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

    //图片
    self.takeOutImageView = [[UIImageView alloc] init];
    [self addSubview:self.takeOutImageView];
    
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = UIColorFromRGB(0x666666);
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
}

-(void)layoutSubviews {

    self.takeOutImageView.frame = CGRectMake(0, 0, 50, 50);
    self.titleLabel.frame = CGRectMake(-10, self.takeOutImageView.bottom + 7, 70, 12);
}

@end
