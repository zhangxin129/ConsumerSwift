//
//  CellShowBtDevicesCell.m
//  company
//
//  Created by liangzm on 15-4-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYPOSCardReaderShowCell.h"

@implementation GYPOSCardReaderShowCell

- (void)awakeFromNib
{
    //设置字体，颜色
    [super awakeFromNib];

    self.lbCellLabel.font = kCellTitleFont;
   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.customBorderType = UIViewCustomBorderTypeTop | UIViewCustomBorderTypeBottom;
}

@end
