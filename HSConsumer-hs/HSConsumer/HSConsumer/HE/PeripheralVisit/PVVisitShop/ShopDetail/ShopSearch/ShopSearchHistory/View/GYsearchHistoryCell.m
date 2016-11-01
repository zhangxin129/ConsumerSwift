//
//  GYsearchHistoryCell.m
//  HSConsumer
//
//  Created by Apple03 on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYsearchHistoryCell.h"
#import "GYsearchHistoryFrameModel.h"
#import "GYseachhistoryModel.h"
@interface GYsearchHistoryCell ()
@property (nonatomic, weak) UILabel* lbDetail;
@end

@implementation GYsearchHistoryCell

+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    GYsearchHistoryCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYsearchHistoryCell];
    if (!cell) {
        cell = [[GYsearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYsearchHistoryCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel* lbDetail = [[UILabel alloc] init];
        lbDetail.backgroundColor = [UIColor clearColor];
        lbDetail.textColor = kCellItemTitleColor;
        lbDetail.font = [UIFont systemFontOfSize:16];
        lbDetail.numberOfLines = 0;
        self.lbDetail = lbDetail;
        [self.contentView addSubview:self.lbDetail];
    }
    return self;
}

- (void)setModel:(GYsearchHistoryFrameModel*)model
{
    _model = model;
    self.lbDetail.text = model.model.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lbDetail.frame = CGRectMake(16, 5, kScreenWidth - 16, 20);
}

@end
