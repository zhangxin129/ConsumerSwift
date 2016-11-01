//
//  FDTakeawayMainCell.m
//  HSConsumer
//
//  Created by apple on 15/12/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDTakeawayMainCell.h"

@implementation FDTakeawayMainCell

- (void)awakeFromNib
{
}

- (void)setModel:(FDShopModel*)model
{
    if (model != nil) {
        _model = model;
        [self.shopPic setImageWithURL:[NSURL URLWithString:model.shopPic] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];

        self.shopName.text = model.shopName;

        if (!model.isInSendRange) {
            self.shopDistance.textColor = self.shopEvgPrice.textColor;
            self.shopDistance.text = kLocalized(@"GYHE_Food_BeyondScopeDelivery");
            self.shopDistance.font = [UIFont systemFontOfSize:8];
        }
        else {
            self.shopDistance.textColor = self.shopAddr.textColor;
            self.shopDistance.text = [NSString stringWithFormat:@"%.2fkm", _model.shopDistance.floatValue];
        }

        self.shopAddr.text = model.shopAddr;
        self.qiSongPriceLabel.text = [NSString stringWithFormat:@"%@%.f", kLocalized(@"GYHE_Food_StartDelivery"), model.qiSongPrice.floatValue];
        //self.fullOffDescLabel.text = model.fullOffDesc;
        if (model.fullOffDesc && ![model.fullOffDesc isEqualToString:kLocalized(@"GYHE_Food_SatisfiedAndSubtract")]) {

            self.fullOffDescLabel.text = model.fullOffDesc;
        }
        else {

            self.fullOffDescLabel.text = @"";
        }

        NSString* shopPoint = model.shopPoint;
        CGFloat shopScore = [shopPoint floatValue];
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

        self.shopEvgPrice.text = [NSString stringWithFormat:@"%@ %@", kLocalized(@"GYHE_Food_PerCapita"), model.shopEvgPrice];
        CGFloat sendPrice = model.sendPrice.floatValue;
        if (model.costSend) {
            sendPrice = model.costSend.floatValue;
        }
        self.sendPriceLabel.text = [NSString stringWithFormat:@"%@ %.f", kLocalized(@"GYHE_Food_SendPrice"), sendPrice];
    }
}

- (void)setTagScoreViewWithScore:(NSInteger)score
{
    UIImage* image0 = [UIImage imageNamed:@"gyhe_food_flower1"];
    UIImage* image1 = [UIImage imageNamed:@"gyhe_food_flower2"];
    UIImage* image2 = [UIImage imageNamed:@"gyhe_food_flower3"];

    switch (score) {
    case 5:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image0;
        break;
    case 4:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image1;
        break;
    case 3:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image2;
        break;
    case 2:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image1;
        _scoreImageView2.image = image2;
        break;
    case 1:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image2;
        _scoreImageView2.image = image2;
        break;

    default:
        _scoreImageView0.image = image2;
        _scoreImageView1.image = image2;
        _scoreImageView2.image = image2;
        break;
    }
}

@end
