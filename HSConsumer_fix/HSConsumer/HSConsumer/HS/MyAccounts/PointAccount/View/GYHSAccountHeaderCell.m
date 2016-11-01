//
//  GYHSAccountHeaderCell.m
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAccountHeaderCell.h"

@implementation GYHSAccountHeaderCell

- (void)awakeFromNib
{
    // Initialization code
}
- (void)setHeaderModel:(GYHSHeaderModel*)headerModel
{
    _titleImage.image = [UIImage imageNamed:@"hs_cell_img_points_account"];
    _topLabel.text = kLocalized(@"GYHS_MyAccounts_point_account_balance");
    _centerLabel.text = kLocalized(@"GYHS_MyAccounts_available_Points");
    _bottomLabel.text = kLocalized(@"GYHS_MyAccounts_today_point");
    _linelabel.hidden = NO;
    _toprightLabel.text = [GYUtils formatCurrencyStyle:[headerModel.IntegralBalance doubleValue]];
    _centerRightLabel.text = [GYUtils formatCurrencyStyle:[headerModel.AvailableIntegral doubleValue]];
    _bottomRightLabel.text = [GYUtils formatCurrencyStyle:[headerModel.TodayIntegral doubleValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
