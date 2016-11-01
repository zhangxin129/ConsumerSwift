//
//  GYdownpaymentCell.m
//  HSConsumer
//
//  Created by appleliss on 15/9/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYdownpaymentCell.h"

@implementation GYdownpaymentCell

- (void)awakeFromNib
{
    self.titl.text = kLocalized(@"GYHE_Food_PrepaidDeposit");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
