//
//  GYHDAddFriendCell.m
//  HSConsumer
//
//  Created by shiang on 16/3/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAddFriendCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDAddFriendModel.h"

@interface GYHDAddFriendCell ()

///**头像*/
//@property (nonatomic, weak) UIImageView* headImageView;
///**昵称*/
//@property (nonatomic, weak) UILabel* nikeNameLabel;
/**添加状态*/
@property (nonatomic, weak) UIButton* searchStatusButton;
/**
 *  添加状态
 */
@property (nonatomic, weak) UILabel* searchStatusLabel;
@end

@implementation GYHDAddFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
//    UIImageView* headImageView = [[UIImageView alloc] init];
//    [self.contentView addSubview:headImageView];
//    _headImageView = headImageView;
//
//    UILabel* nikeNameLabel = [[UILabel alloc] init];
//    [self.contentView addSubview:nikeNameLabel];
//    _nikeNameLabel = nikeNameLabel;

    UILabel* searchStatusLabel = [[UILabel alloc] init];
    searchStatusLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    searchStatusLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:searchStatusLabel];
    _searchStatusLabel = searchStatusLabel;

    UIButton* searchStatusButton = [[UIButton alloc] init];
    searchStatusButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];

    [searchStatusButton setBackgroundImage:[UIImage imageNamed:@"gyhd_text_field_send_icom"] forState:UIControlStateNormal];
    [searchStatusButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:searchStatusButton];
    _searchStatusButton = searchStatusButton;

    WS(weakSelf);
//    [headImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
//        make.centerY.equalTo(weakSelf.contentView);
//        make.left.mas_equalTo(12);
//        make.size.mas_equalTo(CGSizeMake(44, 44));
//    }];

    [searchStatusLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(weakSelf.leftImageView);

    }];

    [searchStatusButton mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(weakSelf.leftImageView);
        make.size.mas_equalTo(CGSizeMake(60, 35));
    }];
    [self.leftBottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-80);
    }];
//    [nikeNameLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(headImageView.mas_right).offset(2);
//        make.centerY.equalTo(headImageView.mas_centerY);
//        make.right.equalTo(searchStatusButton.mas_left).offset(-10);
//    }];
}

- (void)setModel:(GYHDAddFriendModel*)model
{
    _model = model;

    [self.leftImageView setImageWithURL:[NSURL URLWithString:model.addHeadImageUrlString] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];

    self.leftTopLabel.text = model.addNikeNameString;
    self.leftBottomLabel.text = model.addExtraMessage;
    switch (model.addUserStatus) {
    case 0:
        [self.searchStatusButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_add"] forState:UIControlStateNormal];
        self.searchStatusButton.hidden = NO;
        self.searchStatusLabel.text = nil;
        break;
    case 1:
        self.searchStatusButton.hidden = YES;
        self.searchStatusLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Awaiting_verification"];
        break;
    case 2:
        self.searchStatusLabel.text = [GYUtils localizedStringWithKey:@"GYHD_ADD_success"];
        self.searchStatusButton.hidden = YES;
        break;
    case -1:
        [self.searchStatusButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_agree"] forState:UIControlStateNormal];
        self.searchStatusButton.hidden = NO;
        self.searchStatusLabel.text = nil;
        break;
    default:
        break;
    }
}

- (void)searchButtonClick
{
    if ([self.delegate respondsToSelector:@selector(GYHDAddFriendCell:model:)]) {
        [self.delegate GYHDAddFriendCell:self model:self.model];
    }
    //    if ([self.delegate respondsToSelector:@selector(GYHDAddFriendCellbtnClick)]) {
    //        [self.delegate GYHDAddFriendCellDelegate];
    //    }
}

@end
