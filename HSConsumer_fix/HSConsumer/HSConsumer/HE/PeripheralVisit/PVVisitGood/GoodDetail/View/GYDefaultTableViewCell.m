//
//  GYDefaultTableViewCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/7/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYDefaultTableViewCell.h"
#define kGYDefaultTableViewCell @"GYDefaultTableViewCell"

@implementation GYDefaultTableViewCell

+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    GYDefaultTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYDefaultTableViewCell];
    if (!cell) {
        cell = [[GYDefaultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYDefaultTableViewCell];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect rect = self.textLabel.frame;
    rect.origin.x = 20;
    self.textLabel.frame = rect;
}

@end
