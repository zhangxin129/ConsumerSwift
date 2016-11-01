//
//  GYOrderTableViewCell.m
//  HSConsumer
//
//  Created by appleliss on 15/10/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderTableViewCell.h"

@implementation GYOrderTableViewCell
+ (instancetype)cellWithTableView:(UITableView*)tableView andtitleName:(NSString*)titleName andValue:(NSString*)string
{
    GYOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"kGYOrderTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYOrderTableViewCell class]) owner:nil options:nil] lastObject];
    }
    cell.labValue.text = [NSString stringWithFormat:@"%0.2f", [string floatValue]];
    cell.labtitle.text = titleName;
    return cell;
}

- (void)awakeFromNib
{
    self.labtitle.text = kLocalized(@"GYHE_Food_OrderAmount");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
