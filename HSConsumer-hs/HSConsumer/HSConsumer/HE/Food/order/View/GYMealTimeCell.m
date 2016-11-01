//
//  GYMealTimeCell.m
//  HSConsumer
//
//  Created by appleliss on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMealTimeCell.h"

@implementation GYMealTimeCell
+ (instancetype)cellWithTableView:(UITableView*)tableView andindes:(NSIndexPath*)indexPath
{
    GYMealTimeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"kGYMealTimeCell"];
    if (cell) {
        cell = [[GYMealTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kGYMealTimeCell"];
    }

    return cell;
}

- (void)awakeFromNib
{
    self.title.text = kLocalized(@"GYHE_Food_AppointTime");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
