//
//  GYHEMoreMenusCell.m
//  HSConsumer
//
//  Created by kuser on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEMoreMenusCell.h"
#import "UIButton+GYExtension.h"

@implementation GYHEMoreMenusCell

- (void)awakeFromNib {
    // Initialization code

    [_titleBtn setBackgroundColor:kClearColor];
    [_titleBtn setTitleColor:kCorlorFromHexcode(0x666666) forState:UIControlStateNormal];
    [_titleBtn setBorderWithWidth:1.0 andRadius:2.0 andColor:kCorlorFromHexcode(0xcccccc)];
    
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_titleBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick
{
    NSLog(@"点击了");
}

@end
