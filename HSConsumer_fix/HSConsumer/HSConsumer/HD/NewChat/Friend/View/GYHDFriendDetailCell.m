//
//  GYHDFriendDetailCell.m
//  HSConsumer
//
//  Created by shiang on 16/1/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDFriendDetailCell.h"
#import "GYHDFriendDetailModel.h"
#import "Masonry.h"

@interface GYHDFriendDetailCell ()
/**用户信息*/
@property (nonatomic, weak) UILabel* userInfoLabel;
/**用户信息名字*/
@property (nonatomic, weak) UILabel* userInfoNameLabel;
// add zhangxin 创建右边指示箭头
@property (nonatomic, strong)UIImageView*tipImgView;

@end

@implementation GYHDFriendDetailCell

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
    userInfoLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
    [self.contentView addSubview:userInfoLabel];
    _userInfoLabel = userInfoLabel;

    UILabel* userInfoNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:userInfoNameLabel];
    _userInfoNameLabel = userInfoNameLabel;
    WS(weakSelf);
    [userInfoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.mas_greaterThanOrEqualTo(41);
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
    [userInfoNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.mas_equalTo(15);
    }];
    
    _tipImgView=[[UIImageView alloc]init];
    
    _tipImgView.image=[UIImage imageNamed:@"hs_cell_btn_right_arrow"];
    
    
    [self.contentView addSubview:_tipImgView];
    
    
    [_tipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(10, 20));
    }];
    
    _tipImgView.hidden=YES;
    
}

- (void)setFriendDetailModel:(GYHDFriendDetailModel*)friendDetailModel
{
    _friendDetailModel = friendDetailModel;
    self.userInfoLabel.text = friendDetailModel.userInfo;
    self.userInfoNameLabel.text = friendDetailModel.userInfoName;
    
    if ([_userInfoNameLabel.text isEqualToString:@"备注"] || [_userInfoNameLabel.text isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_classification"]] ) {
        
        _tipImgView.hidden=NO;
    }
}

@end
