//
//  GYHEEasyBuyListCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEEasyBuyListCell.h"


@implementation GYHEEasyBuyListCell

- (void)awakeFromNib {
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = kCorlorFromHexcode(0x403000);
    self.detailAddressLabel.font = [UIFont systemFontOfSize:13];
    self.detailAddressLabel.textColor = kCorlorFromHexcode(0x666666);
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.textColor = kCorlorFromHexcode(0x999999);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(GYHEEasyBuyListModel *)model
{
    self.priceImageView.image = [UIImage imageNamed:@"gy_he_coin_icon"];
    self.integralImageView.image = [UIImage imageNamed:@"gy_he_pv_icon"];
    self.sellerImageView.image = [UIImage imageNamed:@"gyhe_good_detail2"];
    self.addressImageView.image = [UIImage imageNamed:@"gyhe_city"];
    _model = model;
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.iconImage] placeholder:[UIImage imageNamed:@"gy_he_example_icon"]];
    self.titleLabel.text = model.title;
    self.priceLabel.text = model.price;
    self.integralLabel.text = model.pv;
    self.detailAddressLabel.text = model.companyName;
    self.addressLabel.text = model.city;
}
@end
