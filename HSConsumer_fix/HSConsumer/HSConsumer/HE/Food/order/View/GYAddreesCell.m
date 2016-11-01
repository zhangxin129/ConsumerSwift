//
//  GYAddreesCell.m
//  HSConsumer
//
//  Created by appleliss on 15/9/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddreesCell.h"

@implementation GYAddreesCell

- (void)awakeFromNib
{
    self.lbNametitle.text = [kLocalized(@"GYHE_Food_ContactPeoper") stringByAppendingString:@":"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModer:(GYOrderModel*)moder
{
}

- (IBAction)addressbtn:(id)sender
{
    DDLogDebug(@"联系地址");
}

@end
