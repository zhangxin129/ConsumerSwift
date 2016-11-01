//
//  GYHDAddFriendDetailCell.m
//  HSConsumer
//
//  Created by shiang on 16/4/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAddFriendDetailCell.h"
#import "GYHDAddFriendDetailModel.h"
#import "Masonry.h"

@interface GYHDAddFriendDetailCell ()
/**用户信息*/
@property (nonatomic, weak) UILabel* userInfoLabel;
/**用户信息名字*/
@property (nonatomic, weak) UILabel* userInfoNameLabel;

@end

@implementation GYHDAddFriendDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return self;
    [self setup];
    return self;
}

- (void)setup
{
    UILabel* userInfoLabel = [[UILabel alloc] init];
    userInfoLabel.numberOfLines = 0;
    [self.contentView addSubview:userInfoLabel];
    _userInfoLabel = userInfoLabel;

    UILabel* userInfoNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:userInfoNameLabel];
    _userInfoNameLabel = userInfoNameLabel;

    [userInfoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.mas_greaterThanOrEqualTo(45);
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];

    [userInfoNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(15);
    }];
}

- (void)setModel:(GYHDAddFriendDetailModel*)model
{
    _model = model;
    self.userInfoLabel.text = model.infoDetail;
    self.userInfoNameLabel.text = model.infoName;
}

@end
