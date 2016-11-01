//
//  GYShopLocationTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopLocationTableViewCell.h"

@implementation GYShopLocationTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    //添加上面的分割线
    CALayer* topLayer = [CALayer layer];
    topLayer.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"gyhe_line_confirm_dialog_yellow"]] CGColor];
    topLayer.frame = CGRectMake(self.frame.origin.x + 16, 0, CGRectGetWidth(self.frame) - 32, 1);
    [self.layer addSublayer:topLayer];

    self.btnShopTel.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.btnShopTel.titleLabel.font = kGYOtherDescriptionFont;
    self.lbGoodName.font = kBigTitleFont;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.lbGoodName.textColor = kDetailBlackColor;

    self.lbShopAddress.textColor = kDetailGrayColor;
    self.lbDistance.textColor = kDetailBlackColor;
    self.lbDistance.font = kGYOtherDescriptionFont;
    [self.btnShopTel setTitleColor:kDetailBlackColor forState:UIControlStateNormal];

    [self.btnCheckMap setTitle:kLocalized(@"GYHE_SurroundVisit_LookMap") forState:UIControlStateNormal];
    [self.btnCheckMap setTitleColor:kPriceRedColor forState:UIControlStateNormal];
    self.btnCheckMap.titleLabel.font = kGYOtherDescriptionFont;
    self.lbDistance.text = @"--";
    self.lbDistance.adjustsFontSizeToFitWidth = YES;
    self.imgvMapIcon.image = [UIImage imageNamed:@"gyhe_map_shopdetail_map.png"];
    [self.imgvSeproter addRightBorder];

    self.lbShopAddress.numberOfLines = 0;
    self.lbShopAddress.font = kGYTitleDescriptionFont;

    self.lbGoodName.numberOfLines = 0;
    self.lbGoodName.lineBreakMode = NSLineBreakByWordWrapping;
}

@end
