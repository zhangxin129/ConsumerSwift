//
//  CellForMyOrderSubCell.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "CellForMyOrderSubCell.h"

@implementation CellForMyOrderSubCell

- (void)awakeFromNib
{
    // Initialization code
    //    [self.viewContentBkg addTopBorderAndBottomBorder];
    [self.lbGoodsName setTextColor:kCorlorFromHexcode(0X464646)];
    self.lbGoodsName.font = [UIFont systemFontOfSize:14];
    //[self.lbGoodsPrice setTextColor:kCellItemTitleColor];
    [self.lbGoodsCnt setTextColor:kCellItemTextColor];
    [self.lbGoodsProperty setTextColor:kCorlorFromHexcode(0XA0A0A0)];
    self.lbGoodsProperty.font = [UIFont systemFontOfSize:13];
    [GYUtils setFontSizeToFitWidthWithLabel:self.lbGoodsPrice labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:self.lbGoodsCnt labelLines:1];

    self.lbGoodsName.numberOfLines = 2;
    self.lbGoodsName.minimumScaleFactor = 12;
    self.lbGoodsName.adjustsFontSizeToFitWidth = YES;

    self.lbGoodsProperty.numberOfLines = 2;
    self.lbGoodsProperty.minimumScaleFactor = 8;
    self.lbGoodsProperty.adjustsFontSizeToFitWidth = YES;
    
    self.pvLabel.hidden = YES;
    self.pvImgView.hidden = YES;
    self.ivHsbLogo.hidden = YES;
    self.lbGoodsPrice.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self addTopBorderAndBottomBorder];
    //    [self.viewContentBkg addTopBorderAndBottomBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
