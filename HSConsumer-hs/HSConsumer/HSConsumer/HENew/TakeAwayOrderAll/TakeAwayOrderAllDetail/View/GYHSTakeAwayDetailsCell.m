//
//  GYHSTakeAwayDetailsCell.m
//  HSConsumer
//
//  Created by kuser on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSTakeAwayDetailsCell.h"
#import "GYHSTakeAwayDetailAllModel.h"

@implementation GYHSTakeAwayDetailsCell

- (void)awakeFromNib
{
    // Initialization code

    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textColor = kCorlorFromHexcode(0x3f3000);
    self.priceLabel.font = [UIFont systemFontOfSize:13];
    self.priceLabel.textColor = kCorlorFromHexcode(0xff5000);
    self.pvLabel.font = [UIFont systemFontOfSize:13];
    self.pvLabel.textColor = kCorlorFromHexcode(0x1d7dd6);
    self.countLabel.font = [UIFont systemFontOfSize:13];
    self.countLabel.textColor = kCorlorFromHexcode(0x3f3000);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GYHSTakeAwayOrderDetailsCellModel*)model
{
    _model = model;
    self.titleLabel.text = model.title;
    self.pvLabel.text = [GYUtils formatCurrencyStyle:[model.pv doubleValue]];
    self.priceLabel.text = [GYUtils formatCurrencyStyle:[model.price doubleValue]];
    self.countLabel.text = [NSString stringWithFormat:@"x%@", model.count];
}

@end
