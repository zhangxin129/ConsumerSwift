//
//  GYEasybuySearchDetailCell.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuySearchGoodsListCell.h"

@interface GYEasybuySearchGoodsListCell ()
@property (weak, nonatomic) IBOutlet UIImageView* imgView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* priceLabel;
@property (weak, nonatomic) IBOutlet UILabel* pvLabel;
@property (weak, nonatomic) IBOutlet UIView* typeView;
@property (weak, nonatomic) IBOutlet UILabel* monthCountLabel;
@property (weak, nonatomic) IBOutlet UILabel* companyLabel;
@property (weak, nonatomic) IBOutlet UILabel* cityLabel;

@property (weak, nonatomic) IBOutlet UIImageView* coinImgView;
@property (weak, nonatomic) IBOutlet UIImageView* pvImgView;

@end

@implementation GYEasybuySearchGoodsListCell

- (void)awakeFromNib
{
    // Initialization code
    _pvImgView.image = [UIImage imageNamed:@"gyhe_about_pv_image"];
    _coinImgView.image = [UIImage imageNamed:@"gyhe_food_coin"];
}

- (void)setModel:(GYEasybuySearchGoodsDetailModel*)model
{
    _model = model;
    if (model) {

        _model = model;
        [_imgView setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
        _nameLabel.text = model.title;
        _priceLabel.text = [NSString stringWithFormat:@"%.2f", model.price.doubleValue];
        _pvLabel.text = [NSString stringWithFormat:@"%.2f", model.pv.doubleValue];
        _monthCountLabel.text = [NSString stringWithFormat:kLocalized(@"GYHE_Easybuy_total_count"), model.salesCount];
        _companyLabel.text = model.vShopName;
        _cityLabel.text = model.city;

        //设置“卷”，“即”，“卖”，“现”，“提”
        NSArray* arrData = [NSArray arrayWithObjects:
                                        model.beTicket,
                                    model.beReach,
                                    model.beSell,
                                    model.beCash,
                                    model.beTake,
                                    nil];
        NSArray* imageNames = @[ @"gyhe_good_detail5", @"gyhe_good_detail1", @"gyhe_good_detail2", @"gyhe_good_detail3", @"gyhe_good_detail4" ];
        CGFloat width = 16;
        for (UIView* view in self.typeView.subviews) {
            [view removeFromSuperview];
        }

        NSInteger index = arrData.count;
        CGFloat border = 2;
        for (NSInteger i = 0, j = 0; i < index; i++) {
            UIImageView* imageView = [[UIImageView alloc] init];

            if ([arrData[i] isEqualToString:@"1"]) {
                CGFloat imgX = (i - j) * (width + border);
                imageView.frame = CGRectMake(imgX, 0, width, width);
                if(imageNames.count > i)
                    imageView.image = [UIImage imageNamed:imageNames[i]];
                [self.typeView addSubview:imageView];
            }
            else {
                j++;
            }

        }

    }

}

@end
