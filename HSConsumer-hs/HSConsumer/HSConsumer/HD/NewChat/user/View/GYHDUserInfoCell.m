//
//  GYHDUserInfoCell.m
//  HSConsumer
//
//  Created by shiang on 16/3/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDUserInfoCell.h"
#import "GYHDUserInfoModel.h"
#import "GYHDMessageCenter.h"

@interface GYHDUserInfoCell ()
/**用户基本信息*/
@property (nonatomic, weak) UILabel* userInfoLabel;
/**用户基本信息名字*/
@property (nonatomic, weak) UILabel* userInfoNameLabel;
/**头像*/
@property (nonatomic, weak) UIImageView* iconImageView;
@end

@implementation GYHDUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
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
    [moreImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.mas_equalTo(-12);
    }];
}

- (void)setModel:(GYHDUserInfoModel*)model
{
    _model = model;
    _userInfoNameLabel.text = model.userInfoName;

    if ([model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_avatar"]]) {
        self.iconImageView.hidden = NO;
        //        if (!self.iconImageView.image) {
        if ([model.userInfo hasPrefix:@"http"]) {

            [self.iconImageView setImageWithURL:[NSURL URLWithString:model.userInfo] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
        }
        else {
//            NSString* imageUrl = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, model.userInfo];

            [self.iconImageView setImageWithURL:[NSURL fileURLWithPath:model.userInfo] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
        }
        //        }
    }
    else {
        self.iconImageView.hidden = YES;
        _userInfoLabel.text = model.userInfo;
    }
}

- (void)setIconWithImage:(UIImage*)image
{
    _iconImageView.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
