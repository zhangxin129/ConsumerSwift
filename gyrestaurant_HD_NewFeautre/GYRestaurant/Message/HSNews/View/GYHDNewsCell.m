//
//  GYHDNewsCell.m
//  HSEnterprise
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDNewsCell.h"

@implementation GYHDNewsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView *iconImageView = [[UIImageView alloc]init];
    iconImageView.contentMode = UIViewContentModeScaleToFill;
    iconImageView.backgroundColor = [UIColor yellowColor];
    [self addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(200, 150));
    }];
    
    UILabel *titleName = [[UILabel alloc]init];
    titleName.text = @"互生创始人何开秀被聘为中国管理科学院行业发展研究所名誉所长";
    titleName.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    titleName.numberOfLines = 2;
    titleName.font = [UIFont systemFontOfSize:20.0];
    [self addSubview:titleName];
    [titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.left.equalTo(iconImageView.mas_right).offset(15);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *detailsLabel = [[UILabel alloc]init];
    detailsLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    detailsLabel.numberOfLines = 0;
    detailsLabel.font = [UIFont systemFontOfSize:16.0];
    detailsLabel.text = @"sankakhafkjahfkahfkjsdfhsdk fhsdkfjhsd kfjhsdfkshdf kjsdhfksd fsdhf s";
    [self addSubview:detailsLabel];
    [detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleName.mas_bottom).offset(5);
        make.left.equalTo(iconImageView.mas_right).offset(15);
        make.right.mas_equalTo(-15);
        make.height.height.mas_equalTo(85);
    }];
}

@end
