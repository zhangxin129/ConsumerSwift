//
//  GYHDSeachMessageCell.m
//  HSConsumer
//
//  Created by shiang on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSeachMessageCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDSeachMessageModel.h"

//@interface GYHDSeachMessageCell ()
///**
// *  昵称label
// */
//@property (nonatomic, weak) UILabel* userNameLabel;
///**
// *  头像ImageView;
// */
//@property (nonatomic, weak) UIImageView* iconImageView;
///**
// *  消息体Label
// */
//@property (nonatomic, weak) UILabel* messageContentLabel;
///**
// *  时间
// */
//@property (nonatomic, weak) UILabel* lasttimeLabel;
//@end

@implementation GYHDSeachMessageCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setup];
//    }
//    return self;
//}
//
//- (void)setup
//{
//    WS(weakSelf);
//    // 头像
//    UIImageView* iconImageView = [[UIImageView alloc] init];
//    iconImageView.layer.masksToBounds = YES;
//    iconImageView.layer.cornerRadius = 3.0f;
//    [self.contentView addSubview:iconImageView];
//    _iconImageView = iconImageView;
//    [iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.size.mas_equalTo(CGSizeMake(44.0f, 44.0f));
//        make.left.top.mas_equalTo(12.0f);
//    }];
//
//    UILabel* lasttimeLabel = [[UILabel alloc] init];
//    lasttimeLabel.font = [UIFont systemFontOfSize:11.0f];
//    lasttimeLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
//    lasttimeLabel.textAlignment = NSTextAlignmentRight;
//    [self.contentView addSubview:lasttimeLabel];
//    _lasttimeLabel = lasttimeLabel;
//
//    [lasttimeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.right.mas_equalTo(-12.0f);
//        make.top.equalTo(weakSelf.iconImageView);
//        make.height.equalTo(weakSelf.iconImageView.mas_height).multipliedBy(0.5);
//    }];
//
//    // 名称
//    UILabel* userNameLabel = [[UILabel alloc] init];
//    userNameLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
//    [self.contentView addSubview:userNameLabel];
//    _userNameLabel = userNameLabel;
//    [userNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.top.equalTo(weakSelf.iconImageView);
//        make.left.equalTo(weakSelf.iconImageView.mas_right).with.offset(10.0f);
//        make.height.equalTo(weakSelf.iconImageView.mas_height).multipliedBy(0.5);
//        make.right.equalTo(weakSelf.lasttimeLabel.mas_left);
//    }];
//
//    //消息
//
//    UILabel* messageContentLabel = [[UILabel alloc] init];
//    messageContentLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
//    messageContentLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
//    [self.contentView addSubview:messageContentLabel];
//    _messageContentLabel = messageContentLabel;
//
//    [messageContentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(weakSelf.userNameLabel);
//        make.bottom.equalTo(weakSelf.iconImageView.mas_bottom);
//        make.height.equalTo(weakSelf.iconImageView.mas_height).multipliedBy(0.5);
//        make.right.mas_equalTo(-47.0f);
//    }];
//}

- (void)setModel:(GYHDSeachMessageModel*)model
{
    _model = model;
    self.leftTopLabel.attributedText = model.seachAttName;
    self.leftBottomLabel.attributedText = model.seachAttContent;
    NSURL *imageUrl = nil;
    if ([model.seachIcon hasPrefix:@"http"]) {
        imageUrl = [NSURL URLWithString:model.seachIcon];
    }else {
        imageUrl = [NSURL fileURLWithPath:model.seachIcon];
    }
    [self.leftImageView setImageWithURL:imageUrl placeholder:kLoadPng(@"gyhd_defaultheadimg") options:kNilOptions completion:nil];
    self.rightTopLabel.text = model.seachTime;
}

@end
