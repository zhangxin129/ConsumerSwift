//
//  GYEasybuySearchShopsCell.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuySearchShopsListCell.h"

@interface GYEasybuySearchShopsListCell ()
@property (weak, nonatomic) IBOutlet UIImageView* imgView;
@property (weak, nonatomic) IBOutlet UILabel* shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel* hsNumLabel;
@property (weak, nonatomic) IBOutlet UIView* typeView;
@property (weak, nonatomic) IBOutlet UILabel* addressLabel;
@property (weak, nonatomic) IBOutlet UILabel* phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel* goodEvaluationLabel;

@property (weak, nonatomic) IBOutlet UIImageView* locaImgView;
@property (weak, nonatomic) IBOutlet UIImageView* phoneImgView;

@end

@implementation GYEasybuySearchShopsListCell

- (void)awakeFromNib
{
    // Initialization code
    _locaImgView.image = [UIImage imageNamed:@"gyhe_food_location"];
    _phoneImgView.image = [UIImage imageNamed:@"gycommon_btn_phone"];
}
- (void)setModel:(GYEasybuySearchShopsDetailModel*)model
{
    _model = model;
    [_imgView setImageWithURL:[NSURL URLWithString:model.pic] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions progress:nil transform:nil completion:nil];
    _shopNameLabel.text = model.vShopName;
    _distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", [model.dist doubleValue]];
    _hsNumLabel.text = [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_Easybuy_HS_card_number"), model.companyResourceNo];
    _addressLabel.text = model.addr;
    _phoneLabel.text = model.hotline;
    _goodEvaluationLabel.text = [NSString stringWithFormat:@"%@%@%%", kLocalized(@"GYHE_Easybuy_good_evaluation"), model.rate];

    //设置“卷”，“即”，“卖”，“现”，“提”
    NSArray* arrData = [NSArray arrayWithObjects:
                                    model.beTicket,
                                model.beReach,
                                model.beSell,
                                model.beCash,
                                model.beTake,
                                nil];
    NSArray* imageNames = @[ @"gyhe_good_detail5", @"gyhe_good_detail1", @"gyhe_good_detail2", @"gyhe_good_detail3", @"gyhe_good_detail4" ];
    CGFloat width = 13;
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

@end
