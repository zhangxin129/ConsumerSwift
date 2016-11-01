//
//  GYStarTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYStarTableViewCell.h"

@implementation GYStarTableViewCell {
    __weak IBOutlet UIImageView* imgvArrow; //箭头imgv
}

- (void)awakeFromNib
{
    // Initialization code
    [self setButtonBackgroundImage:_btnStar1 WithTag:101];
    [self setButtonBackgroundImage:_btnStar2 WithTag:102];
    [self setButtonBackgroundImage:_btnStar3 WithTag:103];
    [self setButtonBackgroundImage:_btnStar4 WithTag:104];
    [self setButtonBackgroundImage:_btnStar5 WithTag:105];

    [self.contentView setBackgroundColor:[UIColor whiteColor]];

    _lbPoint.textColor = [UIColor orangeColor];
    _lbEvaluatePerson.textColor = kCellItemTitleColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setButtonBackgroundImage:(UIButton*)button WithTag:(int)tag
{
    [button setBackgroundImage:[UIImage imageNamed:@"gyhe_collocate_star_gray"] forState:UIControlStateNormal];
    button.tag = tag;
    [button setBackgroundImage:[UIImage imageNamed:@"gyhe_collocate_star_yellow"] forState:UIControlStateSelected];
}

- (void)refreshUIWithModel:(ShopModel*)model
{
}

@end
