//
//  FDSearchFoodsCell.m
//  HSConsumer
//
//  Created by apple on 15/12/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDSearchFoodsCell.h"

@implementation FDSearchFoodsCell

- (void)awakeFromNib
{
}

- (void)setModel:(FDSearchFoodsModel*)model
{

    _model = model;

    [_foodPic setImageWithURL:[NSURL URLWithString:model.itemPics] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];

    _foodName.text = model.itemName;

    _foodPrice.text = [NSString stringWithFormat:@"%.2f", [model.price floatValue]];

    _foodPv.text = [NSString stringWithFormat:@"%.2f", [model.itemPv floatValue]];

    _foodSaleNum.text = [NSString stringWithFormat:@"%@%ld%@", kLocalized(@"GYHE_Food_TotalSales"), (long)model.itemSale, kLocalized(@"GYHE_Food_Part")];

    CGFloat shopScore = model.score;
    NSInteger score = 0;
    if (shopScore == 0) {
        score = 0;
    }
    else if (shopScore > 0 && shopScore <= 60) {
        score = 1;
    }
    else if (shopScore > 60 && shopScore <= 70) {
        score = 2;
    }
    else if (shopScore > 70 && shopScore <= 80) {
        score = 3;
    }
    else if (shopScore > 80 && shopScore <= 90) {
        score = 4;
    }
    else if (shopScore > 90 && shopScore <= 100) {
        score = 5;
    }
    [self setTagScoreViewWithScore:score];
}

- (void)setTagScoreViewWithScore:(NSInteger)score
{
    UIImage* image0 = [UIImage imageNamed:@"gyhe_food_flower1"];
    UIImage* image1 = [UIImage imageNamed:@"gyhe_food_flower2"];
    UIImage* image2 = [UIImage imageNamed:@"gyhe_food_flower3"];

    switch (score) {
    case 5:
        _scoreImage0.image = image0;
        _scoreImage1.image = image0;
        _scoreImage2.image = image0;
        break;
    case 4:
        _scoreImage0.image = image0;
        _scoreImage1.image = image0;
        _scoreImage2.image = image1;
        break;
    case 3:
        _scoreImage0.image = image0;
        _scoreImage1.image = image0;
        _scoreImage2.image = image2;
        break;
    case 2:
        _scoreImage0.image = image0;
        _scoreImage1.image = image1;
        _scoreImage2.image = image2;
        break;
    case 1:
        _scoreImage0.image = image0;
        _scoreImage1.image = image2;
        _scoreImage2.image = image2;
        break;

    default:
        _scoreImage0.image = image2;
        _scoreImage1.image = image2;
        _scoreImage2.image = image2;
        break;
    }
}

- (IBAction)addAction:(UIButton *)sender {



}

@end
