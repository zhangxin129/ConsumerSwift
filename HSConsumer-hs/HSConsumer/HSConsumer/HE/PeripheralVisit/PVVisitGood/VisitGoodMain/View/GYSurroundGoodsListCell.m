//
//  GYAroundGoodsListCell.m
//  GYHSConsumer_SurroundVisit
//
//  Created by apple on 16/3/18.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurroundGoodsListCell.h"
#define kTextColor kCorlorFromRGBA(120, 120, 120, 1);
#define kTextFont [UIFont systemFontOfSize:10]

@interface GYSurroundGoodsListCell ()

@property (weak, nonatomic) IBOutlet UIImageView* imgView;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;

@end

@implementation GYSurroundGoodsListCell

- (void)reloadData:(GYSurroundGoodsListModel*)model
{
    [self.imgView setImageWithURL:[NSURL URLWithString:model.picAddr] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
    self.titleLabel.text = model.categoryName;
}

- (void)awakeFromNib
{
    _titleLabel.textColor = kTextColor;
    _titleLabel.font = kTextFont;
}

@end
