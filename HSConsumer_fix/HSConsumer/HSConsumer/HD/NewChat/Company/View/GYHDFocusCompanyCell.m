//
//  GYHDFocusCompanyCell.m
//  HSConsumer
//
//  Created by shiang on 16/3/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDFocusCompanyCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDFocusCompanyGroupModel.h"

@interface GYHDFocusCompanyCell ()
///**企业名字*/
//@property (nonatomic, weak) UILabel* focusCompanyNameLabel;
///**企业详细*/
//@property (nonatomic, weak) UILabel* focusCompanyDetailLabel;
///**企业头像*/
//@property (nonatomic, weak) UIImageView* focusCompanyIconImageView;
///**声音提示*/
//@property (nonatomic, weak) UIImageView* voicePromptsImgaeView;
@end

@implementation GYHDFocusCompanyCell

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
//    UIImageView* FocusCompanyIconImageView = [[UIImageView alloc] init];
//    FocusCompanyIconImageView.layer.masksToBounds = YES;
//    FocusCompanyIconImageView.layer.cornerRadius = 3.0f;
//    [self.contentView addSubview:FocusCompanyIconImageView];
//    _focusCompanyIconImageView = FocusCompanyIconImageView;
//
//    UILabel* FocusCompanyNameLabel = [[UILabel alloc] init];
//    FocusCompanyNameLabel.textColor = [UIColor colorWithRed:114 / 255.0f green:147 / 255.0f blue:207 / 255.0f alpha:1];
//    FocusCompanyNameLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
//    [self.contentView addSubview:FocusCompanyNameLabel];
//    _focusCompanyNameLabel = FocusCompanyNameLabel;
//
//    UILabel* FocusCompanyDetailLabel = [[UILabel alloc] init];
//    FocusCompanyDetailLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
//    FocusCompanyDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(24.0f)];
//    [self.contentView addSubview:FocusCompanyDetailLabel];
//    _focusCompanyDetailLabel = FocusCompanyDetailLabel;
//
//    UIImageView* VoicePromptsImgaeView = [[UIImageView alloc] init];
//    [self.contentView addSubview:VoicePromptsImgaeView];
//    _voicePromptsImgaeView = VoicePromptsImgaeView;
//
//    [FocusCompanyIconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.size.mas_equalTo(CGSizeMake(44.0f, 44.0f));
//        make.left.top.mas_equalTo(12.0f);
//    }];
//
//    [FocusCompanyNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(FocusCompanyIconImageView.mas_right).offset(12);
//        make.right.mas_equalTo(-24);
//        make.top.equalTo(FocusCompanyIconImageView.mas_top);
//        make.height.equalTo(FocusCompanyIconImageView.mas_height).multipliedBy(0.5);
//    }];
//
//    [FocusCompanyDetailLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(FocusCompanyIconImageView.mas_right).offset(12);
//        make.bottom.equalTo(FocusCompanyIconImageView);
//        make.height.equalTo(FocusCompanyIconImageView.mas_height).multipliedBy(0.5);
//        make.right.mas_equalTo(-47.0f);
//    }];
//
//    [VoicePromptsImgaeView mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.right.mas_equalTo(-35);
//        make.centerY.equalTo(FocusCompanyIconImageView);
//    }];
//}

- (void)setModel:(GYHDFocusCompanyModel*)model
{
    _model = model;
    [self.leftImageView setImageWithURL:[NSURL URLWithString:model.focusCompanyIcon] placeholder:[UIImage imageNamed:@"gyhd_defaultCompany"] options:kNilOptions completion:nil];
    self.leftTopLabel.textColor = [UIColor colorWithRed:114 / 255.0f green:147 / 255.0f blue:207 / 255.0f alpha:1];
    self.leftTopLabel.text = model.focusCompanyName;
    self.leftBottomLabel.text = model.focusCompanyDetail;
}

@end
