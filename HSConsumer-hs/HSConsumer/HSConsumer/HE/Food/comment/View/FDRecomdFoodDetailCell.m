//
//  FDRecomdFoodDetailCell.m
//  HSConsumer
//
//  Created by apple on 15/12/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDRecomdFoodDetailCell.h"

@implementation FDRecomdFoodDetailCell

- (void)awakeFromNib
{

    [self.topBgView addBottomBorder];
    self.recomdFoodLabel.text = kLocalized(@"GYHE_Food_RecommendedDishes");
}

- (void)setRecomdFoods:(NSArray*)recomdFoods
{

    _recomdFoods = recomdFoods;

    NSString* str = [recomdFoods componentsJoinedByString:@"   "];

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, self.recomFoodBgView.bounds.size.width - 10, self.recomFoodBgView.bounds.size.height)];
    label.text = str;
    label.numberOfLines = 0;
    CGFloat hight = [GYUtils heightForString:str fontSize:12 andWidth:kScreenWidth -20];
    label.frame = CGRectMake(5, 2, kScreenWidth - 20, hight);
    label.font = [UIFont systemFontOfSize:12];

    [self.recomFoodBgView addSubview:label];

}

@end
