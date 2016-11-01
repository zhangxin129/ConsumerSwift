//
//  GYHDDingDanCell.m
//  HSConsumer
//
//  Created by shiang on 16/1/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMessageListCell.h"
#import "GYHDMessageListModel.h"
#import "GYHDMessageCenter.h"

@interface GYHDMessageListCell ()
/**
 * 消息标题
 */
@property (nonatomic, weak) UILabel* messageListTitleLabel;
/**
 * 消息内容
 */
@property (nonatomic, weak) UILabel* messageListContentLabel;
/**
 * 消息时间
 */
@property (nonatomic, weak) UILabel* messageListTimerLabel;
@end

@implementation GYHDMessageListCell

//+ (instancetype)cellWithTableView:(UITableView*)tableView
//{
//    static NSString* identifierString = @"GYHDDingDanListCellID";
//    GYHDMessageListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
//    if (cell == nil) {
//        cell = [[GYHDMessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
//    }
//    return cell;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return self;

    // 1.消息标题
    UILabel* messageListTitleLabel = [[UILabel alloc] init];
    messageListTitleLabel.font = [UIFont systemFontOfSize:17.0f];
    messageListTitleLabel.textColor = [UIColor colorWithRed:26.0f / 255.0f green:26.0f / 255.0f blue:26.0f / 255.0f alpha:1];
    [self.contentView addSubview:messageListTitleLabel];
    self.messageListTitleLabel = messageListTitleLabel;

    [messageListTitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.mas_equalTo(12);
        make.right.mas_equalTo(-80);
    }];

    UILabel* messageListContentLabel = [[UILabel alloc] init];
    messageListContentLabel.font = [UIFont systemFontOfSize:12.0f];
    messageListContentLabel.textColor = [UIColor colorWithRed:153.0f / 255.0f green:153.0f / 255.0f blue:153.0f / 255.0f alpha:1];
    messageListContentLabel.numberOfLines = 0;
    [self.contentView addSubview:messageListContentLabel];
    self.messageListContentLabel = messageListContentLabel;
    ;

    [messageListContentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(messageListTitleLabel.mas_bottom).offset(6);
        make.left.mas_equalTo(12.0f);
        make.right.mas_equalTo(-47.5f);
        make.bottom.mas_equalTo(-12);
    }];

    UILabel* messageListTimerLabel = [[UILabel alloc] init];
    messageListTimerLabel.font = [UIFont systemFontOfSize:11.0f];
    messageListTimerLabel.textColor = [UIColor colorWithRed:153.0f / 255.0f green:153.0f / 255.0f blue:153.0f / 255.0f alpha:1];
    [self.contentView addSubview:messageListTimerLabel];
    self.messageListTimerLabel = messageListTimerLabel;
    [messageListTimerLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-12);
        make.top.height.equalTo(messageListTitleLabel);
    }];
    return self;
}

- (void)setDingDanModel:(GYHDMessageListModel*)dingDanModel
{
    _dingDanModel = dingDanModel;
    self.messageListTitleLabel.text = dingDanModel.messageListTitle;
    self.messageListContentLabel.attributedText = dingDanModel.messageListContentAttributedStr;
    self.messageListTimerLabel.text = dingDanModel.messageListTimer;

}

@end
