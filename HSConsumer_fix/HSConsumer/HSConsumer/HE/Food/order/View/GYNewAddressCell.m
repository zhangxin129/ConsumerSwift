//
//  GYNewAddressCell.m
//  HSConsumer
//
//  Created by appleliss on 15/10/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYNewAddressCell.h"

@implementation GYNewAddressCell

+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    GYNewAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"kGYNewAddressCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GYNewAddressCell" owner:nil options:nil] lastObject];
    }

    return cell;
}

- (void)setAddmodel:(AddrModel*)addmodel
{
    self.userName.text = addmodel.consignee;
    self.userIphone.text = addmodel.mobile;
    //    self.addLableHeight.constant = 50;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
