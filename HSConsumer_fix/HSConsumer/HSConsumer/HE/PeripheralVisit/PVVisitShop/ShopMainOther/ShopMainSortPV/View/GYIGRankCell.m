//
//  GYIGRankCell.m
//  HSConsumer
//
//  Created by apple on 15/11/18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYIGRankCell.h"

@implementation GYIGRankCell

- (void)awakeFromNib
{
}

- (void)refreshUIWith:(ShopModel*)model
{

    self.model = model;

    [_shopIcon setImageWithURL:[NSURL URLWithString:model.strShopPictureURL] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder.png"] options:kNilOptions completion:nil];

    BOOL str = [GYUtils isBlankString:model.strCompanyName];

    _shopName.text = [model.strCompanyName isEqualToString:@"<null>"] || str == YES ? [NSString stringWithFormat:@""] : model.strCompanyName;
    _shopName.textColor = kDetailBlackColor;

    _shopAdressLabel.text = [NSString stringWithFormat:@"%@", model.strShopAddress];
    _shopAdressLabel.textColor = kDetailGrayColor;

    _distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", model.shopDistance.floatValue];
    _distanceLabel.textColor = kDetailGrayColor;

    _shopTipLabel.text = model.categoryNames;
    _shopTipLabel.textColor = kDetailGrayColor;

    CGFloat point = [model.pointsProportion floatValue];

    _igPrecentLabel.text = [NSString stringWithFormat:@"%@：%.2f%%", kLocalized(@"GYHE_SurroundVisit_ProportionalIntegral"), point];
    _igPrecentLabel.textColor = kDetailGrayColor;

    _adressCenterLabel.text = model.section;
    _adressCenterLabel.textColor = kgrayTextColor;
}

@end
