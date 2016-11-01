//
//  GYHDSearchUserInfoCell.m
//  HSConsumer
//
//  Created by wangbiao on 16/9/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchUserInfoCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDSearchUserDetailModel.h"

@interface GYHDSearchUserInfoCell ()
/**用户基本信息*/
@property (nonatomic, weak) UILabel* userInfoLabel;
/**用户基本信息名字*/
@property (nonatomic, weak) UILabel* userInfoNameLabel;
/**头像*/
@property (nonatomic, weak) UIImageView* iconImageView;
@end
@implementation GYHDSearchUserInfoCell

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
    UILabel* userInfoLabel = [[UILabel alloc] init];
    userInfoLabel.numberOfLines = 0;
    userInfoLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
    [self.contentView addSubview:userInfoLabel];
    _userInfoLabel = userInfoLabel;
    
    UILabel* userInfoNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:userInfoNameLabel];
    _userInfoNameLabel = userInfoNameLabel;
    
    UIImageView* moreImageView = [[UIImageView alloc] init];
    moreImageView.image = [UIImage imageNamed:@"gyhd_more_gd"];
    [self.contentView addSubview:moreImageView];
    UIImageView* iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:iconImageView];
    _iconImageView = iconImageView;
    WS(weakSelf);
    [userInfoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.mas_greaterThanOrEqualTo(45);
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.equalTo(userInfoLabel);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [userInfoNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.mas_equalTo(15);
        
    }];
//    [moreImageView mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.centerY.equalTo(weakSelf.contentView);
//        make.right.mas_equalTo(-12);
//    }];
}

- (void)setModel:(GYHDSearchUserDetailModel *)model {
    _model = model;
    self.userInfoNameLabel.text = model.userInfoName;
    self.userInfoLabel.text = model.userInfo;
}
@end
