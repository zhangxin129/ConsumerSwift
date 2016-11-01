//
//  GYHESCConfirmOrderTableViewCell.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/28.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHESCConfirmOrderTableViewCell.h"

@implementation GYHESCConfirmOrderTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshDataWithModel:(GYHESCCartListModel*)model
{
    [self.pictureImageView setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
    self.describleLabel.text = model.title;
    self.skuLabel.text = model.sku;
    self.numberLabel.text = [NSString stringWithFormat:@"x%@", model.count];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", [model.price doubleValue]];
    self.pvLabel.text = [NSString stringWithFormat:@"%.2f", [model.pv doubleValue]];
}

@end
