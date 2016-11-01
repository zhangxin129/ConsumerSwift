//
//  GYHDSearchMessageListCell.m
//  HSConsumer
//
//  Created by shiang on 16/7/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchMessageListCell.h"

@implementation GYHDSearchMessageListCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setModel:(GYHDSearchMessageListModel *)model {
    _model = model;
    if ([model.iconString hasPrefix:@"http"]) {
        [self.leftImageView setImageWithURL:[NSURL URLWithString:model.iconString] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    }else {
        self.leftImageView.image = [UIImage imageNamed:model.iconString];
    }
    self.leftTopLabel.text = model.nameString;
    self.leftBottomLabel.attributedText = model.detailAttributedString;
    self.rightTopLabel.text = model.timeString;
}
@end
