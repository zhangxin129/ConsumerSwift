//
//  GYHDAttentionIndustryCell.m
//  HSConsumer
//
//  Created by shiang on 16/3/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAttentionIndustryCell.h"
#import "GYHDAttentionIndustryModel.h"
#import "GYHDMessageCenter.h"

@interface GYHDAttentionIndustryCell ()
/**行业标题*/
@property (nonatomic, weak) UILabel* industryTitleLabel;
/**行业副标题*/
@property (nonatomic, weak) UILabel* industrySubtitleLabel;
/**行业图片*/
@property (nonatomic, weak) UIImageView* industryImageView;
@end

@implementation GYHDAttentionIndustryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UILabel* industryTitle = [[UILabel alloc] init];
    industryTitle.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    [self.contentView addSubview:industryTitle];
    _industryTitleLabel = industryTitle;

    UILabel* industrydeSubtitle = [[UILabel alloc] init];
    industrydeSubtitle.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    industrydeSubtitle.textColor = [UIColor colorWithRed:132 / 255.0f green:132 / 255.0f blue:132 / 255.0f alpha:1];
    [self.contentView addSubview:industrydeSubtitle];
    _industrySubtitleLabel = industrydeSubtitle;

    UIImageView* industryImageView = [[UIImageView alloc] init];
    industryImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:industryImageView];
    _industryImageView = industryImageView;

    [industryTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(25);
    }];
    [industrydeSubtitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(industryTitle.mas_bottom);
    }];

    [industryImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)setModel:(GYHDAttentionIndustryModel*)model
{
    _model = model;
    self.industryTitleLabel.text = model.industryTitle;
    self.industrySubtitleLabel.text = model.industrySubtitle;
    NSURL* url = [NSURL URLWithString:model.industryImageUrl];
    [self.industryImageView setImageWithURL:url placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
}

@end
