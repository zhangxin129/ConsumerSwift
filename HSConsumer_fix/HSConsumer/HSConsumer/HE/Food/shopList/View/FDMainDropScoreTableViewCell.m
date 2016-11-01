//
//  FDMainDropScoreTableViewCell.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define scoreRed ([UIColor colorWithRed:254 / 255.0 green:71 / 255.0 blue:66 / 255.0 alpha:1])
#import "FDMainDropScoreTableViewCell.h"

@interface FDMainDropScoreTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView0;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView1;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView2;
@property (weak, nonatomic) IBOutlet UILabel* scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView* scoreChoosed;

@end

@implementation FDMainDropScoreTableViewCell

- (void)awakeFromNib
{

    self.scoreLabel.text = kLocalized(@"GYHE_Food_Excellent");
}

- (void)setChoosed:(BOOL)choosed
{
    if (choosed) {
        _scoreChoosed.image = [UIImage imageNamed:@"gyhe_check_mark_red"];
        _scoreLabel.textColor = scoreRed;
    }
    else {
        _scoreChoosed.image = [UIImage imageNamed:@""];
        _scoreLabel.textColor = [UIColor blackColor];
    }
}

- (void)setScore:(NSInteger)score
{
    if (score > 5) {
        return;
    }
    NSArray* scoreStr = @[ kLocalized(@"GYHE_Food_Excellent"), kLocalized(@"GYHE_Food_Fine"), kLocalized(@"GYHE_Food_Recommend"), kLocalized(@"GYHE_Food_Proposal"), kLocalized(@"GYHE_Food_Common") ];
    _scoreLabel.text = scoreStr[score];
    UIImage* image0 = [UIImage imageNamed:@"gyhe_food_flower1"];
    UIImage* image1 = [UIImage imageNamed:@"gyhe_food_flower2"];
    UIImage* image2 = [UIImage imageNamed:@"gyhe_food_flower3"];

    switch (score) {
    case 0:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image0;
        break;
    case 1:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image1;
        break;
    case 2:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image2;
        break;
    case 3:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image1;
        _scoreImageView2.image = image2;
        break;
    case 4:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image2;
        _scoreImageView2.image = image2;
        break;

    default:
        break;
    }

}

@end
