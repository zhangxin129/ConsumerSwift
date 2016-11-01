//
//  GYHEAddShoppingCarCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEAddShoppingCarCell.h"

@implementation GYHEAddShoppingCarCell


-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(instancetype)init {

    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

    
    UIImage *unselect = [UIImage imageNamed:@"gyhe_goods_unselect_shop"];
    UIImage *select = [UIImage imageNamed:@"gyhe_goods_select_shop"];
    unselect =[unselect resizableImageWithCapInsets:UIEdgeInsetsMake(13, 14, 13, 14) resizingMode:UIImageResizingModeStretch];
    select = [select resizableImageWithCapInsets:UIEdgeInsetsMake(13, 14, 13, 14) resizingMode:UIImageResizingModeStretch];
    
    self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleBtn.titleLabel.lineBreakMode   = NSLineBreakByTruncatingTail;
    self.titleBtn.userInteractionEnabled = NO;
    self.titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;
    self.titleBtn.frame = CGRectMake(0, 0, 30, 27);
    [self.titleBtn setTitleColor:UIColorFromRGB(0x00101e) forState:UIControlStateNormal];
    [self.titleBtn setBackgroundImage:unselect forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    [self.titleBtn setBackgroundImage:select forState:UIControlStateSelected];
    [self.titleBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateDisabled];
    [self.titleBtn setBackgroundImage:unselect forState:UIControlStateDisabled];
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleBtn.layer.cornerRadius = 8;
    self.titleBtn.clipsToBounds = YES;
    [self addSubview:self.titleBtn];
    
}


@end
