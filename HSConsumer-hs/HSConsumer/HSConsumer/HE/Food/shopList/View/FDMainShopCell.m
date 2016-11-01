//
//  FDMainShopCell.m
//  HSConsumer
//
//  Created by apple on 15/12/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDMainShopCell.h"

@implementation FDMainShopCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FDShopModel*)model
{
    _model = model;
    if (model != nil) {
        _model = model;
        _shopLabel.text = model.shopName;
        [_shopImageView setImageWithURL:[NSURL URLWithString:model.shopPic] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
        _cashLabel.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHE_Food_PerCapita"), model.shopEvgPrice];
        _shopAdressLabel.text = model.shopAddr;

        //            if (model.mealType!=nil) {
        //
        //                NSData*jsonData=[model.mealType dataUsingEncoding:NSUTF8StringEncoding];
        //
        //                NSArray*arr=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        //
        //                DDLogDebug(@"arr===%@",arr);
        //
        //                NSMutableArray*tempArr=[NSMutableArray array];
        //
        //                for (NSDictionary*dict in arr) {
        //
        //                    [tempArr addObject:dict[@"value"]];
        //
        //                }
        //
        //                NSString*mealTypeStr=[tempArr componentsJoinedByString:@" "];
        //
        //               _shopTipLabel.text=mealTypeStr;
        //
        //            }

        if (model.businessType != nil) {

            NSData* jsonData = [model.businessType dataUsingEncoding:NSUTF8StringEncoding];

            NSArray* arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

            NSMutableArray* tempArr = [NSMutableArray array];

            for (NSDictionary* dict in arr) {

                [tempArr addObject:dict[@"value"] ? dict[@"value"] : @""]; //防止数据库数据中的value为空，做此项兼容数据，防止闪退
            }

            NSString* mealTypeStr = [tempArr componentsJoinedByString:@" "];

            _shopTipLabel.text = mealTypeStr;
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

        _shopDistanceLabel.text = [NSString stringWithFormat:@"%.2fkm", _model.shopDistance.floatValue];
    }

    [self setIconCout];
}

- (void)setTagScoreViewWithScore:(NSInteger)score
{
    UIImage* image0 = [UIImage imageNamed:@"gyhe_food_flower1"];
    UIImage* image1 = [UIImage imageNamed:@"gyhe_food_flower2"];
    UIImage* image2 = [UIImage imageNamed:@"gyhe_food_flower3"];

    switch (score) {
    case 5: //3个
        _scroeImageViewleft.image = image0;
        _scoreImageViewcenter.image = image0;
        _scoreImageViewRight.image = image0;
        break;
    case 4: //2个半
        _scroeImageViewleft.image = image0;
        _scoreImageViewcenter.image = image0;
        _scoreImageViewRight.image = image1;
        break;
    case 3: //2个
        _scroeImageViewleft.image = image0;
        _scoreImageViewcenter.image = image0;
        _scoreImageViewRight.image = image2;
        break;
    case 2: //1个半
        _scroeImageViewleft.image = image0;
        _scoreImageViewcenter.image = image1;
        _scoreImageViewRight.image = image2;
        break;
    case 1: //1个
        _scroeImageViewleft.image = image0;
        _scoreImageViewcenter.image = image2;
        _scoreImageViewRight.image = image2;
        break;

    default: //没有
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

    if (self.model.tickets) {

        str1 = @"1";
    }
    if (self.model.takeOut) {

        str2 = @"1";
    }
    if (self.model.appointment) {

        str3 = @"1";
    }

    if (self.model.parking) {

        str4 = @"1";
    }

    if (self.model.pickUp) {

        str5 = @"1";
    }

    NSArray* arrData = [NSArray arrayWithObjects:
                                    str1,
                                str2,
                                str3,
                                str4,
                                str5, nil];

    NSArray* imageNames = @[ @"gyhe_food_main_ticket", @"gyhe_food_main_wai", @"gyhe_food_main_order", @"gyhe_food_main_stop", @"gyhe_food_main_ti" ];
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
            imageView.frame = CGRectMake(kScreenWidth - 10 - iconWith * (index - j + 1), self.shopLabel.frame.origin.y + 3, iconWith, iconWith);
            imageView.image = [UIImage imageNamed:imageNames[i]];
            [self addSubview:imageView];
        } else {
            j++;
        }

    }

}

@end
