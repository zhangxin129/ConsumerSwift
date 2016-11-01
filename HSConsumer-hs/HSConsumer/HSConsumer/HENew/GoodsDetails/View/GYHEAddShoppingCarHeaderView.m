//
//  GYHEAddShoppingCarHeaderView.m
//  HSConsumer
//
//  Created by lizp on 16/10/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEAddShoppingCarHeaderView.h"

@implementation GYHEAddShoppingCarHeaderView


-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


-(void)setUp {

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth -10, 14)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = UIColorFromRGB(0x00101e);
    [self addSubview:self.titleLabel];
}

@end
