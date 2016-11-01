//
//  GYHDMoveFriendCell.m
//  HSConsumer
//
//  Created by shiang on 16/3/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMoveFriendCell.h"
#import "GYHDMoveFriendGroupModel.h"
#import "GYHDMessageCenter.h"

@interface GYHDMoveFriendCell ()
/**选中状态*/
@property (nonatomic, weak) UIButton* moveFriendStateButton;
/**好友头像*/
@property (nonatomic, weak) UIImageView* moveFriendIconImageView;
/**好友昵称*/
@property (nonatomic, weak) UILabel* moveFriendNikeNameLabel;
@end

@implementation GYHDMoveFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIButton* moveFriendStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    moveFriendStateButton.userInteractionEnabled = NO;
    [moveFriendStateButton setBackgroundImage:[UIImage imageNamed:@"gyhd_move_friend_btn_normal"] forState:UIControlStateNormal];
    [moveFriendStateButton addTarget:self action:@selector(btnClck) forControlEvents:UIControlEventTouchUpInside];
    [moveFriendStateButton setBackgroundImage:[UIImage imageNamed:@"gyhd_move_friend_btn_select"] forState:UIControlStateSelected];
    [self.contentView addSubview:moveFriendStateButton];
    _moveFriendStateButton = moveFriendStateButton;

    UIImageView* moveFriendIconImageView = [[UIImageView alloc] init];
    moveFriendIconImageView.image = [UIImage imageNamed:@"gyhd_defaultheadimg"];
    [self.contentView addSubview:moveFriendIconImageView];
    _moveFriendIconImageView = moveFriendIconImageView;

    UILabel* moveFriendNikeNameLabel = [[UILabel alloc] init];
    moveFriendNikeNameLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
    [self.contentView addSubview:moveFriendNikeNameLabel];
    _moveFriendNikeNameLabel = moveFriendNikeNameLabel;
    WS(weakSelf);
    [moveFriendStateButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.mas_equalTo(15);
    }];

    [moveFriendIconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(moveFriendStateButton);
        make.left.equalTo(moveFriendStateButton.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(44.0f, 44.0f));
    }];

    [moveFriendNikeNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(moveFriendStateButton);
        make.left.equalTo(moveFriendIconImageView.mas_right).offset(12);
    }];
}

- (void)setModel:(GYHDMoveFriendModel*)model
{
    _model = model;

    self.moveFriendNikeNameLabel.text = model.moveFriendNikeName;
    [self.moveFriendIconImageView setImageWithURL:[NSURL URLWithString:model.moveFriendIconUrl] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    if (model.TeamSelf) {

        [self.moveFriendStateButton setBackgroundImage:[UIImage imageNamed:@"gyhd_move_friend_btn_Disabled"] forState:UIControlStateNormal];
    }
    else {

        [self.moveFriendStateButton setBackgroundImage:[UIImage imageNamed:@"gyhd_move_friend_btn_normal"] forState:UIControlStateNormal];
    }
    if (model.moveFriendSelectState) {
        self.moveFriendStateButton.selected = YES;
    }
    else {
        self.moveFriendStateButton.selected = NO;
    }
}
- (void)btnClck
{
    if (!self.model.TeamSelf) {

        self.model.moveFriendSelectState = self.moveFriendStateButton.selected = !self.moveFriendStateButton.selected;
    }

}
@end
