//
//  FDMainFoodTableViewCell.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDMainShopTableViewCell.h"

@interface FDMainShopTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel* shopName;
@property (weak, nonatomic) IBOutlet UIImageView* shopPic;
@property (weak, nonatomic) IBOutlet UILabel* shopEvgPrice;
@property (weak, nonatomic) IBOutlet UILabel* shopAddr;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView0;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView1;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView2;
@property (weak, nonatomic) IBOutlet UILabel* shopDistanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView* tickets;
@property (weak, nonatomic) IBOutlet UIImageView* parking;
@property (weak, nonatomic) IBOutlet UIImageView* appointment;

@end

@implementation FDMainShopTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (IBAction)scoreImageViewClicked:(UIButton*)sender
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FDShopModel*)model
{
    if (model != nil) {
        _model = model;
        _shopName.text = model.shopName;
        [_shopPic setImageWithURL:[NSURL URLWithString:model.shopPic] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
        _shopEvgPrice.text = model.shopEvgPrice;
        _shopAddr.text = model.shopAddr;
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

        model.tickets ? (_tickets.image = [UIImage imageNamed:@"gyhe_food_main_ticket1"]) : (_tickets.image = [UIImage imageNamed:@"gyhe_food_main_ticket2"]);
        model.parking ? (_parking.image = [UIImage imageNamed:@"gyhe_food_main_stop1"]) : (_parking.image = [UIImage imageNamed:@"gyhe_food_main_stop2"]);
        model.appointment ? (_appointment.image = [UIImage imageNamed:@"gyhe_food_main_order1"]) : (_appointment.image = [UIImage imageNamed:@"gyhe_food_main_order2"]);
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
