//
//  GYShowShopsCell.m
//  HSConsumer
//
//  Created by apple on 15/11/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShowShopsCell.h"

@implementation GYShowShopsCell

- (void)awakeFromNib
{

    _telImage.center = _telBtn.center;
}

- (void)refreshUIWith:(ShopModel*)model
{

    self.model = model;

    [_shopIcon setImageWithURL:[NSURL URLWithString:model.strShopPictureURL] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];

    BOOL str = [GYUtils isBlankString:model.strCompanyName];

    _shopLabel.text = [model.strCompanyName isEqualToString:@"<null>"] || str == YES ? [NSString stringWithFormat:@""] : model.strCompanyName;

    _shopAdressLabel.text = [NSString stringWithFormat:@"%@", model.strShopAddress];

    _distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", model.shopDistance.floatValue];

    _tipLabelOne.text = model.categoryNames;

    [self setIconCout];
}

- (void)setIconCout
{

    //add by zhnagqy  iOS消费者--轻松购--商品展示列表中特色服务排列建议与安卓（UI）一致
    NSArray* arrData = [NSArray arrayWithObjects:
                                    self.model.beTake,
                                self.model.beCash,
                                self.model.beSell,
                                self.model.beReach,
                                //                         self.model.beQuan,
                                nil];
    //    NSArray *imageNames = @[@"gyhe_good_detail4",@"gyhe_good_detail3",@"gyhe_good_detail2",@"gyhe_good_detail1",@"gyhe_good_detail5"];
    NSArray* imageNames = @[ @"gyhe_good_detail4", @"gyhe_good_detail3", @"gyhe_good_detail2", @"gyhe_good_detail1" ];
    CGFloat iconWith = 15;
    for (int i = 25; i < 30; i++) {
        UIView* view = [self viewWithTag:i];
        if (view != nil) {
            [view removeFromSuperview];
        }
    }
    NSInteger index = arrData.count - 1;
    for (NSInteger i = index, j = index; i >= 0; i--, j--) {
        UIImageView* imageView = [[UIImageView alloc] init];

        if ([arrData[i] isEqualToString:@"1"]) {
            imageView.tag = 25 + j;
            imageView.frame = CGRectMake(_shopAdressLabel.frame.origin.x + iconWith * (index - j + 1) - 4 * i, CGRectGetMaxY(_shopAdressLabel.frame) + 1, iconWith, iconWith);
            if(imageNames.count > i)
                imageView.image = [UIImage imageNamed:imageNames[i]];
            [self addSubview:imageView];
        }
        else {
            j++;
        }
    }
}

- (void)setCellDataWith:(GYSearchShopsMainModel*)model
{

    self.MainModel = model;

    [_shopIcon setImageWithURL:[NSURL URLWithString:model.shopPic] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];

    BOOL str = [GYUtils isBlankString:model.companyName];

    _shopLabel.text = [model.companyName isEqualToString:@"<null>"] || str == YES ? [NSString stringWithFormat:@""] : model.companyName;

    _shopAdressLabel.text = [NSString stringWithFormat:@"%@", model.addr];

    _distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", model.dist.floatValue];

    _tipLabelOne.text = model.categoryNames;

    [self setIcon];
}

- (void)setIcon
{

    NSArray* arrData = [NSArray arrayWithObjects:
                                    self.MainModel.beTake,
                                self.MainModel.beCash,
                                self.MainModel.beSell,
                                self.MainModel.beReach,
                                self.MainModel.beQuan,
                                nil];
    NSArray* imageNames = @[ @"gyhe_good_detail4", @"gyhe_good_detail3", @"gyhe_good_detail2", @"gyhe_good_detail1", @"gyhe_good_detail5" ];
    CGFloat iconWith = 15;
    for (int i = 25; i < 30; i++) {
        UIView* view = [self viewWithTag:i];
        if (view != nil) {
            [view removeFromSuperview];
        }
    }
    NSInteger index = arrData.count - 1;
    for (NSInteger i = index, j = index; i >= 0; i--, j--) {
        UIImageView* imageView = [[UIImageView alloc] init];

        if ([arrData[i] isEqualToString:@"1"]) {
            imageView.tag = 25 + j;
            imageView.frame = CGRectMake(_shopAdressLabel.frame.origin.x + iconWith * (index - j + 1) - 4 * i, CGRectGetMaxY(_shopAdressLabel.frame) + 1, iconWith, iconWith);
            if(imageNames.count > i)
                imageView.image = [UIImage imageNamed:imageNames[i]];
            [self addSubview:imageView];
        } else {
            j++;
        }

    }
}

@end
