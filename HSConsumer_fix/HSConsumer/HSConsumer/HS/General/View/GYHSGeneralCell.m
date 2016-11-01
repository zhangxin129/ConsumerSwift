//
//  GYHSGeneralCell.m
//  GYHSConsumer_MyHS
//
//  Created by liss on 16/4/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSGeneralCell.h"

@implementation GYHSGeneralCell

- (void)awakeFromNib
{
    // Initialization code

    self.title.textColor = UIColorFromRGB(0x464646);
    self.detileLab.textColor = UIColorFromRGB(0xA0A0A0);
    [self addBottomLayer];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addBottomLayer {
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(15, self.frame.size.height -0.5, kScreenWidth-15, 0.5);
    layer.backgroundColor = kDefaultViewBorderColor.CGColor;
    [self.layer addSublayer:layer];

}

@end
