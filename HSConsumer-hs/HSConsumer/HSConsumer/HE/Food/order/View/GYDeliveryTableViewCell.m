//
//  GYDeliveryTableViewCell.m
//  HSConsumer
//
//  Created by appleliss on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYDeliveryTableViewCell.h"

@implementation GYDeliveryTableViewCell

- (void)awakeFromNib
{
    self.labDeliveryTitle.text = kLocalized(@"GYHE_Food_SendPrice");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
