//
//  CellGoodsNameAndPriceCell.m
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEGoodsNameWithPriceCell.h"

@interface GYHEGoodsNameWithPriceCell ()

@end

@implementation GYHEGoodsNameWithPriceCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.lbGoodsName setTextColor:kCellItemTitleColor];
    [self.lbPrice setTextColor:kValueRedCorlor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(GYHEFocusGoodModel *)model {
    
    _model = model;
    _lbGoodsName.text = model.title;
    _lbPrice.text = model.price;
    [_ivGoodsImage setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"easybuy_placeholder_image"]];
}

@end
