//
//  foodDetailTopCell.m
//  HSConsumer
//
//  Created by apple on 15/12/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "foodDetailTopCell.h"

@implementation foodDetailTopCell

- (void)awakeFromNib
{

    self.sendPriceLabel.text = kLocalized(@"GYHE_Food_SendPrice");
    self.startSendLabel.text = kLocalized(@"GYHE_Food_StartPrice");
    self.perConsumptionLabel.text = kLocalized(@"GYHE_Food_PerCapitaConsume");
}

- (void)setModel:(FDShopModel*)model
{
    //    if (model != nil) {
    //        _model = model;
    //
    //        NSString *shopPoint = model.shopPoint;
    //        CGFloat shopScore = [shopPoint floatValue];
    //        NSInteger score = 0;
    //        if (shopScore == 0) {
    //            score = 0;
    //        }
    //
    //        else if (shopScore<=20) {
    //            score = 1;
    //        }
    //        else if (shopScore>20 &&shopScore<=40)
    //        {
    //            score = 2;
    //        }
    //        else if (shopScore>40 &&shopScore<=60)
    //        {
    //            score = 3;
    //        }
    //        else if (shopScore>60 &&shopScore<=80)
    //        {
    //            score = 4;
    //        }
    //        else if (shopScore>80 &&shopScore<=100)
    //        {
    //            score = 5;
    //        }
    //        [self setTagScoreViewWithScore:score];
    //
    //    }
}

- (void)setShopDetailModel:(FDShopDetailModel*)shopDetailModel
{

    _shopDetailModel = shopDetailModel;

    _startSaleLabel.text = [NSString stringWithFormat:@"%.2f", [shopDetailModel.sendPriceMin doubleValue]];

    _peisongCasheLabel.text = [NSString stringWithFormat:@"%.2f", [shopDetailModel.costSend doubleValue]];
    _averageLabel.text = [NSString stringWithFormat:@"(%ld)", [shopDetailModel.commentCount integerValue]];
    if (shopDetailModel.takeOut) {
        //        _peisongCasheLabel.hidden = NO;
        //        _startSaleLabel.hidden = NO;
        self.startSendView.hidden = NO;
        self.sendPriceView.hidden = NO;
    }
    else {
        //        _peisongCasheLabel.hidden = YES;
        //        _startSaleLabel.hidden = YES;
        self.sendPriceView.hidden = YES;
        self.startSendView.hidden = YES;
    }

    if (shopDetailModel.costAvg != nil) {

        _pinjunCashLabel.text = [NSString stringWithFormat:@"%@", shopDetailModel.costAvg];
    }

    _shopLabel.text = shopDetailModel.shopName;

    if (shopDetailModel.foodTypes != nil) {

        NSData* jsonData = [shopDetailModel.foodTypes dataUsingEncoding:NSUTF8StringEncoding];

        NSArray* arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

        DDLogDebug(@"arr===%@", arr);

        NSMutableArray* tempArr = [NSMutableArray array];

        for (NSDictionary* dict in arr) {

            [tempArr addObject:kSaftToNSString(dict[@"value"])];
        }

        NSString* mealTypeStr = [tempArr componentsJoinedByString:@" "];

        _shopCategaryLabel.text = mealTypeStr;
    }

    _brandLabel.text = shopDetailModel.brand;
    if (shopDetailModel.pics != nil) {

        NSData* jsonData = [shopDetailModel.pics dataUsingEncoding:NSUTF8StringEncoding];

        NSArray* arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

        NSDictionary* dict;
        for (NSInteger i = 0; i < arr.count; i++) {

            if (i == 0) {

                dict = arr[i];
            }
        }

        NSArray* tempArr = dict[@"mobile"];

        NSString* picStr;

        for (NSInteger j = 0; j < tempArr.count; j++) {

            if (j == 0) {

                picStr = tempArr[j][@"name"];
            }
        }

        DDLogDebug(@"%@", picStr);

        picStr = [NSString stringWithFormat:@"%@%@", globalData.tfsDomain, picStr];

        [_shopImageView setImageWithURL:[NSURL URLWithString:picStr] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
    }
    CGFloat shopScore = shopDetailModel.score;
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

    [self setIconCout];
}

- (void)setTagScoreViewWithScore:(NSInteger)score
{
    UIImage* image0 = [UIImage imageNamed:@"gyhe_food_flower1"];
    UIImage* image1 = [UIImage imageNamed:@"gyhe_food_flower2"];
    UIImage* image2 = [UIImage imageNamed:@"gyhe_food_flower3"];

    switch (score) {
    case 5:
        _scroeImageViewleft.image = image0;
        _scoreImageViewcenter.image = image0;
        _scoreImageViewRight.image = image0;
        break;
    case 4:
        _scroeImageViewleft.image = image0;
        _scoreImageViewcenter.image = image0;
        _scoreImageViewRight.image = image1;
        break;
    case 3:
        _scroeImageViewleft.image = image0;
        _scoreImageViewcenter.image = image0;
        _scoreImageViewRight.image = image2;
        break;
    case 2:
        _scroeImageViewleft.image = image0;
        _scoreImageViewcenter.image = image1;
        _scoreImageViewRight.image = image2;
        break;
    case 1:
        _scroeImageViewleft.image = image0;
        _scoreImageViewcenter.image = image2;
        _scoreImageViewRight.image = image2;
        break;

    default:
        _scroeImageViewleft.image = image2;
        _scoreImageViewcenter.image = image2;
        _scoreImageViewRight.image = image2;
        break;
    }
}

- (void)setIconCout
{
    NSString* str1 = @"0";
    NSString* str2 = @"0";
    NSString* str3 = @"0";
    NSString* str4 = @"0";
    NSString* str5 = @"0";

    if (self.shopDetailModel.tickets) {

        str1 = @"1";
    }
    if (self.shopDetailModel.takeOut) {

        str2 = @"1";
    }
    if (self.shopDetailModel.appointment) {

        str3 = @"1";
    }

    if (self.shopDetailModel.parking) {

        str4 = @"1";
    }

    if (self.shopDetailModel.pickUp) {

        str5 = @"1";
    }

    NSArray* arrData = [NSArray arrayWithObjects:
                                    str5,
                                str4,
                                str3,
                                str2,
                                str1,
                                nil];
    NSArray* imageNames = @[ @"gyhe_food_main_ti", @"gyhe_food_main_stop", @"gyhe_food_main_order", @"gyhe_food_main_wai", @"gyhe_food_main_ticket" ];
    CGFloat iconWith = 15;
    for (int i = 25; i < 30; i++) {
        UIView* view = [self viewWithTag:i];
        if (view != nil) {
            [view removeFromSuperview];
        }
    }
    CGRect rect;
    NSInteger index = arrData.count - 1;
    for (NSInteger i = index, j = index; i >= 0; i--, j--) {
        UIImageView* imageView = [[UIImageView alloc] init];

        if ([arrData[i] isEqualToString:@"1"]) {
            imageView.tag = 25 + j;
            imageView.frame = CGRectMake(0 + (iconWith * (index - j + 1) - 4 * i), 5, iconWith, iconWith);
            imageView.image = [UIImage imageNamed:imageNames[i]];

            [self.tipView addSubview:imageView];
        }
        else {
            j++;
        }
        rect = imageView.frame;
    }
    self.tipView.frame = CGRectMake(self.tipView.frame.origin.x, self.tipView.frame.origin.y, CGRectGetMaxY(rect), self.tipView.frame.size.height);
}

- (IBAction)contactShopAction:(UIButton*)sender
{

    if (_block) {

        _block();
    }

}

@end
