//
//  FoodShopDetailCell.m
//  HSConsumer
//
//  Created by apple on 15/12/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FoodShopDetailCell.h"

@implementation FoodShopDetailCell

- (void)awakeFromNib
{
}

- (void)setShopDetailModel:(FDShopDetailModel*)shopDetailModel
{

    _shopDetailModel = shopDetailModel;

    NSString* str = shopDetailModel.introduce;

    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, kScreenWidth - 40, 100)];

    _infoLabel.text = str;

    _infoLabel.font = [UIFont systemFontOfSize:12];

    _infoLabel.numberOfLines = 0;

//    CGFloat height = [GYUtils heightForString:str font:[UIFont systemFontOfSize:12] width:kScreenWidth - 40];
    CGFloat height = [GYUtils heightForString:str fontSize:12 andWidth:kScreenWidth -40];

    _infoLabel.frame = CGRectMake(20, 5, kScreenWidth - 40, height);

    [self addSubview:_infoLabel];



}

@end
