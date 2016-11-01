//
//  GYgreensCell.m
//  HSConsumer
//
//  Created by appleliss on 15/9/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYgreensCell.h"

@implementation GYgreensCell

+ (instancetype)cellWithTableView:(UITableView*)tableView andindes:(NSIndexPath*)indexPath andtitleName:(NSString*)titleName andRMB:(NSString*)stringRMB andPV:(NSString*)stringPV;
{
    GYgreensCell* cell = [tableView dequeueReusableCellWithIdentifier:@"kGYgreensCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GYgreensCell" owner:nil options:nil] lastObject];
    }
    //    cell.lbGreensName.lineBreakMode = UILineBreakModeMiddleTruncation;

    cell.lbGreensName.text = titleName;
    cell.lbGreensPirce.text = stringRMB;
    cell.lbGreensPVPrice.text = stringPV;
    return cell;
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
