//
//  GYHDBaseCell.m
//  HSConsumer
//
//  Created by shiang on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDBaseCell.h"
#import "GYHDMessageCenter.h"


@implementation GYHDBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return self;
    //图片
    UIImageView* leftImageView = [[UIImageView alloc] init];
//    leftImageView.image = kLoadPng(@"gyhd_defaultheadimg");
    leftImageView.layer.masksToBounds = YES;
    leftImageView.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:leftImageView];
    _leftImageView = leftImageView;
    //左上角
    UILabel* leftTopLabel = [[UILabel alloc] init];
    leftTopLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
    [self.contentView addSubview:leftTopLabel];
    _leftTopLabel = leftTopLabel;
    
    //右下角
    UILabel* leftBottomLabel = [[UILabel alloc] init];
    leftBottomLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    leftBottomLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
    [self.contentView addSubview:leftBottomLabel];
    _leftBottomLabel = leftBottomLabel;
    
    //右上角
    UILabel* rightTopLabel = [[UILabel alloc] init];
    rightTopLabel.font = [UIFont systemFontOfSize:11.0f];
    rightTopLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
    [self.contentView addSubview:rightTopLabel];
    _rightTopLabel = rightTopLabel;
    
    [leftImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.width.mas_equalTo( 44.0f);
        make.left.top.mas_equalTo(12.0f);
        make.bottom.mas_equalTo(-12.0f);
    }];
    
    
    [rightTopLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-12.0f);
        make.width.mas_greaterThanOrEqualTo(40);
        make.top.equalTo(leftImageView);

        
    }];
    
    [leftTopLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(leftImageView);
        make.left.equalTo(leftImageView.mas_right).with.offset(10.0f);
        make.height.equalTo(leftImageView).multipliedBy(0.5);
        make.right.lessThanOrEqualTo(rightTopLabel.mas_left).offset(-10);
    }];
    [leftBottomLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(leftImageView);
        make.left.equalTo(leftTopLabel);
        make.right.mas_equalTo(-24);

    }];

    rightTopLabel.text = @"  ";
    return self;
}

@end
