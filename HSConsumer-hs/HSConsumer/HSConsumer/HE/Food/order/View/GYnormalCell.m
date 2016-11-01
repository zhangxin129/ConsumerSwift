//
//  GYnormalCell.m
//  HSConsumer
//
//  Created by appleliss on 15/10/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYnormalCell.h"

@implementation GYnormalCell

+ (instancetype)cellWithTableView:(UITableView*)tableView andindes:(NSIndexPath*)indexPath andtitleName:(NSString*)titleName
{
    GYnormalCell* cell = [tableView dequeueReusableCellWithIdentifier:@"kGYnormalCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYnormalCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(GYcellModel*)model
{
    self.title.text = model.titleString;
    self.value.text = model.valueString;
}

- (void)awakeFromNib
{
    self.title.text = kLocalized(@"GYHE_Food_AppointTimeAndColon");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
