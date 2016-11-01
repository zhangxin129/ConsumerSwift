//
//  FoodBusinessCell.m
//  HSConsumer
//
//  Created by apple on 15/12/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FoodBusinessCell.h"

@implementation FoodBusinessCell

- (void)awakeFromNib
{
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultMarginToBounds, 5, kScreenWidth - 40, 20)];

        lab.text = kLocalized(@"GYHE_Food_BusinessIntelligence");

        lab.font = [UIFont systemFontOfSize:14];

        [self addSubview:lab];

        UIImageView* arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame), 5, 8, 15)];

        arrowView.image = [UIImage imageNamed:@"hs_cell_btn_right_arrow"];

        [self addSubview:arrowView];
    }
    return self;
}

@end
