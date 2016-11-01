//
//  CellForOrderDetailCell.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "CellForOrderDetailCell.h"

@implementation CellForOrderDetailCell

- (void)awakeFromNib
{
    // Initialization code
    [self.lbGoodsName setTextColor:kCorlorFromHexcode(0x464646)];
    self.lbGoodsName.font = [UIFont systemFontOfSize:15];
    [self.lbGoodsCnt setTextColor:kCorlorFromHexcode(0x464646)];
    [self.lbGoodsProperty setTextColor:kCorlorFromHexcode(0xA0A0A0)];
    self.lbGoodsProperty.font = [UIFont systemFontOfSize:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// add by songjk
- (void)toGoodInfo
{
    DDLogDebug(@"跳转商品详情");
    if ([self.delegate respondsToSelector:@selector(CellForOrderDetailCellDidCliciPictureWithCell:)]) {
        [self.delegate CellForOrderDetailCellDidCliciPictureWithCell:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // add by songjk
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toGoodInfo)];
    [self.ivGoodsPicture addGestureRecognizer:tap];
    self.ivGoodsPicture.userInteractionEnabled = YES;

    self.lbGoodsName.numberOfLines = 2;
    self.lbGoodsName.minimumScaleFactor = 12;
    self.lbGoodsName.adjustsFontSizeToFitWidth = YES;

    self.lbGoodsProperty.numberOfLines = 2;
    self.lbGoodsProperty.minimumScaleFactor = 8;
    self.lbGoodsProperty.adjustsFontSizeToFitWidth = YES;

//    [_vLine addTopBorder];
}

@end
