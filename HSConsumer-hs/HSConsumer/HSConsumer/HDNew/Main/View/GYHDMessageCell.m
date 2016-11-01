//
//  GYHDMessageCell.m
//  HSConsumer
//
//  Created by shiang on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMessageCell.h"
#import "GYHDMessageModel.h"

@interface GYHDMessageCell ()
/**
 *  用户头像
 */
//@property (nonatomic, weak) UIImageView* iconImageView;
/**
 *  用户昵称
 */
//@property (nonatomic, weak) UILabel* userNameLabel;
/**
 *  最后一条消息时间
 */
//@property (nonatomic, weak) UILabel* lasttimeLabel;
/**
 *  消息正文
 */
//@property (nonatomic, weak) UILabel* messageContentLabel;
/**
 * 未读消息
 */
@property (nonatomic, weak) UIButton* unreadMessageButton;
@end

@implementation GYHDMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return self;
    WS(weakSelf);
    //未读消息标签
    UIButton* unreadMessageButton = [[UIButton alloc] init];
    unreadMessageButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    unreadMessageButton.imageView.contentMode = UIViewContentModeCenter;
    unreadMessageButton.userInteractionEnabled = NO;
    [self.contentView addSubview:unreadMessageButton];
    _unreadMessageButton = unreadMessageButton;
    [unreadMessageButton setBackgroundImage:[UIImage imageNamed:@"gyhd_unread_tips_icon"] forState:UIControlStateNormal];
    [unreadMessageButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(13.0f, 13.0f));
        make.centerX.equalTo(weakSelf.leftImageView.mas_right);
        make.centerY.equalTo(weakSelf.leftImageView.mas_top);
    }];


    return self;
}

- (void)setMessageModel:(GYHDMessageModel*)messageModel
{
    _messageModel = messageModel;
    //2. 设置控件内容
    [self.leftImageView setImageWithURL:messageModel.userIconUrl placeholder:kLoadPng(@"gyhd_defaultheadimg") options:kNilOptions completion:nil];
    self.leftTopLabel.text = messageModel.userNameStr;
    self.leftTopLabel.textColor = messageModel.userNameColoer;
    self.rightTopLabel.text = messageModel.messageTimeStr;
    self.leftBottomLabel.attributedText = messageModel.messageContentAttributedString;
    [_unreadMessageButton setTitle:messageModel.unreadMessageCountStr forState:UIControlStateNormal];
    if (messageModel.unreadMessageCountStr.integerValue > 0) {
        _unreadMessageButton.hidden = NO;
        if (messageModel.unreadMessageCountStr.integerValue > 9) {
            [_unreadMessageButton mas_updateConstraints:^(MASConstraintMaker* make) {
                make.size.mas_equalTo(CGSizeMake(25.0f, 13.0f));
            }];
        }else {
            [_unreadMessageButton mas_updateConstraints:^(MASConstraintMaker* make) {
                make.size.mas_equalTo(CGSizeMake(13.0f, 13.0f));
            }];
        }
    }
    else {
        _unreadMessageButton.hidden = YES;
    }
    if (messageModel.messageState) {
        self.contentView.backgroundColor = [UIColor colorWithRed:204 / 225.0f green:204 / 225.0f blue:204 / 225.0f alpha:1];
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];

    }
}

@end
