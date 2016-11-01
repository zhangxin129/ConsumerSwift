//
//  GYEasybuyHomeCollectionViewCell.m
//  HSConsumer
//
//  Created by zhangqy on 15/11/10.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import "GYEasybuyHomeCollectionViewCell.h"
#import "UIView+CustomBorder.h"

@implementation GYEasybuyHomeCollectionViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setModel:(GYEasybuyMainModel*)model
{
    _model = model;
    if (model) {
        _model = model;
        self.titleLabel.text = model.title;
        self.subTitleLabel.text = model.subTitle;
        [self.imageView setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
        [self addAllBorder];
    }
}

@end
