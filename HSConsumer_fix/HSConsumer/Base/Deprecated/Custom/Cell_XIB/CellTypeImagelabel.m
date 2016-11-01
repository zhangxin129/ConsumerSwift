//
//  CellTypeImagelabel.m
//  company
//
//  Created by apple on 14-11-12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "CellTypeImagelabel.h"

@implementation CellTypeImagelabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.lbCellLabel setTextColor:UIColorFromRGB(0x464646)];
    self.lbCellLabel.font = [UIFont systemFontOfSize:18];
}

@end
