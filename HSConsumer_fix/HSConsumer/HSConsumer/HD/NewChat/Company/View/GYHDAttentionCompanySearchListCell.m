//
//  GYHDAttentionCompanySearchListCell.m
//  HSConsumer
//
//  Created by shiang on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAttentionCompanySearchListCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDAttentionCompanySearchListModel.h"

@interface GYHDAttentionCompanySearchListCell ()
///**企业名字*/
//@property (nonatomic, weak) UILabel* companyNameLabel;
///**企业详细*/
//@property (nonatomic, weak) UILabel* companyDetailLabel;
///**企业头像*/
//@property (nonatomic, weak) UIImageView* companyIconImageView;

@end

@implementation GYHDAttentionCompanySearchListCell

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
//    UIImageView* companyIconImageView = [[UIImageView alloc] init];
//    companyIconImageView.layer.masksToBounds = YES;
//    companyIconImageView.layer.cornerRadius = 3.0f;
//    [self.contentView addSubview:companyIconImageView];
//    _companyIconImageView = companyIconImageView;
//
//    UILabel* companyNameLabel = [[UILabel alloc] init];
//    companyNameLabel.textColor = [UIColor colorWithRed:114 / 255.0f green:147 / 255.0f blue:207 / 255.0f alpha:1];
//    companyNameLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
//    [self.contentView addSubview:companyNameLabel];
//    _companyNameLabel = companyNameLabel;
//
//    UILabel* companyDetailLabel = [[UILabel alloc] init];
//    companyDetailLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
//    companyDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(24.0f)];
//    [self.contentView addSubview:companyDetailLabel];
//    _companyDetailLabel = companyDetailLabel;
//
//    [companyIconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.size.mas_equalTo(CGSizeMake(44.0f, 44.0f));
//        make.left.top.mas_equalTo(12.0f);
//    }];
//
//    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(companyIconImageView.mas_right).offset(12);
//        make.right.mas_equalTo(-24);
//        make.top.equalTo(companyIconImageView.mas_top);
//        make.height.equalTo(companyIconImageView.mas_height).multipliedBy(0.5);
//    }];
//
//    [companyDetailLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(companyIconImageView.mas_right).offset(12);
//        make.bottom.equalTo(companyIconImageView);
//        make.height.equalTo(companyIconImageView.mas_height).multipliedBy(0.5);
//        make.right.mas_equalTo(-47.0f);
//    }];
//}

- (void)setModel:(GYHDAttentionCompanySearchListModel*)model
{
    _model = model;
    [self.leftImageView setImageWithURL:[NSURL URLWithString:model.companyIcon] placeholder:[UIImage imageNamed:@"gyhd_defaultCompany"] options:kNilOptions completion:nil];
    self.leftTopLabel.textColor = [UIColor colorWithRed:114 / 255.0f green:147 / 255.0f blue:207 / 255.0f alpha:1];
    self.leftTopLabel.text = model.companyTitle;
    self.leftBottomLabel.text = model.companyDetail;
}

@end
