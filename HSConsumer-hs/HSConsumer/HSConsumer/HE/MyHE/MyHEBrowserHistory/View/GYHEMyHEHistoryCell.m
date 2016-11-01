//
//  GYHEMyHEHistoryCell.m
//  HS_Consumer_HE
//
//  Created by Yejg on 16/4/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEMyHEHistoryCell.h"
#import "GYHEMyHEHistory.h"

@interface GYHEMyHEHistoryCell ()



@end

@implementation GYHEMyHEHistoryCell

- (void)awakeFromNib {
    
    CGFloat padding = 10;
    CGFloat x = CGRectGetMinX(self.iconImageView.frame);
    CGFloat y = 11;
    CGFloat w = kScreenWidth - x - padding;
    CGFloat h = 21;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
    titleLabel.textColor = kCellItemTitleColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    self.priceLabel.textColor = kValueRedCorlor;
    self.priceLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setModel:(GYHEMyHEHistory *)model {
    
    _model = model;
//    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
    
    [self.picImageView setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"easybuy_placeholder_image"]];
    self.priceLabel.text = [model.price stringValue];
    self.titleLabel.text = model.name;
}



@end
