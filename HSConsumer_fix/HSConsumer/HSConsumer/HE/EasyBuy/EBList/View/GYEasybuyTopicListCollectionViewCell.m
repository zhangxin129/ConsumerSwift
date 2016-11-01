//
//  GYEasybuyTopicListCollectionViewCell.m
//  HSConsumer
//
//  Created by zhangqy on 15/11/11.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import "GYEasybuyTopicListCollectionViewCell.h"

#import "UIView+CustomBorder.h"

@interface GYEasybuyTopicListCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView* goodsPic;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* priceLabel;
@property (weak, nonatomic) IBOutlet UILabel* pvLabel;
@property (weak, nonatomic) IBOutlet UILabel* monthySalesLabel;
@property (weak, nonatomic) IBOutlet UILabel* companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* cityLabel;
@property (weak, nonatomic) IBOutlet UIView* typeView;
@property (weak, nonatomic) IBOutlet UIView* backView;

@property (weak, nonatomic) IBOutlet UIImageView* coinImgView;
@property (weak, nonatomic) IBOutlet UIImageView* pvImgView;

@end

@implementation GYEasybuyTopicListCollectionViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.backView addLeftBorder];
    
    [self.contentView addBottomBorder];
    [self.contentView setBottomBorderInset:YES];
}

- (void)awakeFromNib
{
    _goodsPic.contentMode =UIViewContentModeScaleAspectFill;
    _goodsPic.clipsToBounds = YES;
    _coinImgView.image = [UIImage imageNamed:@"gyhe_food_coin"];
    _pvImgView.image = [UIImage imageNamed:@"gyhe_about_pv_image"];
}

- (void)setModel:(GYEasybuyTopicListModel*)model
{
    _model = model;
    if (model) {

        _model = model;
        [self.goodsPic setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];

        self.titleLabel.text = model.title;
        self.priceLabel.text = [NSString stringWithFormat:@"%.2f", model.price.doubleValue];
        self.pvLabel.text = [NSString stringWithFormat:@"%.2f", model.pv.doubleValue];
        self.monthySalesLabel.text = [NSString stringWithFormat:kLocalized(@"GYHE_Easybuy_total_count"), model.salesCount.stringValue];
        self.companyNameLabel.text = model.companyName;
        self.cityLabel.text = model.city;

        //设置“卷”，“即”，“卖”，“现”，“提”
        NSArray* arrData = [NSArray arrayWithObjects:
                                        model.beTicket,
                                    model.beReach,
                                    model.beSell,
                                    model.beCash,
                                    model.beTake,
                                    nil];
        NSArray* imageNames = @[ @"gyhe_good_detail5", @"gyhe_good_detail1", @"gyhe_good_detail2", @"gyhe_good_detail3", @"gyhe_good_detail4" ];
        CGFloat width = 15;
        for (UIView* view in self.typeView.subviews) {
            [view removeFromSuperview];
        }

        NSInteger index = arrData.count;
        CGFloat border = 0;
        for (NSInteger i = 0, j = 0; i < index; i++) {
            UIImageView* imageView = [[UIImageView alloc] init];
            if(arrData.count > i) {
                if ([arrData[i] isEqualToString:@"1"]) {
                    CGFloat imgX = (i - j) * (width + border);
                    imageView.frame = CGRectMake(imgX, 0, width, width);
                    if(imageNames.count > i) {
                        imageView.image = [UIImage imageNamed:imageNames[i]];
                    }
                    [self.typeView addSubview:imageView];
                }
                else {
                    j++;
                }
            }
            

        }

    }


}

@end
