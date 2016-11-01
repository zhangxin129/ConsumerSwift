//
//  GYAllShopTableViewCell.m
//  HSConsumer
//
//  Created by apple on 15/6/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAllShopTableViewCell.h"
#import "UIView+Extension.h"

@interface GYAllShopTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView* phoneImageView;

@end
@implementation GYAllShopTableViewCell

- (void)awakeFromNib
{

    self.lbDistance.textColor = kCellItemTextColor;
    self.lbAddr.textColor = kCellItemTextColor;

    [self.btnShopTel setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.phoneImageView.y = CGRectGetMaxY(self.lbAddr.frame);
    self.btnShopTel.y = self.phoneImageView.y;
    [self removeAllBorder];
    [self.contentView addBottomBorder];
    [self.contentView setBottomBorderInset:YES];
}

@end
