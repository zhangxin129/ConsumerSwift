//
//  GYEvaluationTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEvaluationTableViewCell.h"
#import "UIButton+GYextension.h"

@implementation GYEvaluationTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor = kDefaultVCBackgroundColor;
    self.vWhiteBackground.backgroundColor = [UIColor whiteColor];
    self.lbGoodShop.textColor = kCellItemTitleColor;
    self.lbGoodTitle.textColor = kCellItemTextColor;
    self.btnMakeEvalutaion.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUIWithModel:(GYEvaluateGoodModel*)model WithType:(int)cellType;
{
    _model = model;
    [self.imgvGoods setImageWithURL:[NSURL URLWithString:model.url] placeholder:kLoadPng(@"gycommon_image_placeholder") options:kNilOptions completion:nil];
    self.lbGoodShop.text = model.title;
    self.lbGoodTitle.text = model.sku;
    if (cellType == 1) {
        [self.btnMakeEvalutaion setTitle:kLocalized(@"GYHE_MyHE_AlreadyEvaluate") forState:UIControlStateNormal];
        [self.btnMakeEvalutaion setBorderWithWidth:1 andRadius:2 andColor:kCellItemTextColor];
        [self.btnMakeEvalutaion setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    }
    else {
        [self.btnMakeEvalutaion setTitle:kLocalized(@"GYHE_MyHE_MakeEvaluation") forState:UIControlStateNormal];
        [self.btnMakeEvalutaion setBorderWithWidth:1 andRadius:3 andColor:kNavigationBarColor];
        [self.btnMakeEvalutaion setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    }
}
@end
