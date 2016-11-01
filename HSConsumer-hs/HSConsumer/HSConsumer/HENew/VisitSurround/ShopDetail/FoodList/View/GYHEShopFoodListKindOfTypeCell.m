//
//  GYHEShopFoodListKindOfTypeCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/10/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopFoodListKindOfTypeCell.h"

@interface GYHEShopFoodListKindOfTypeCell ()

@property (weak, nonatomic) IBOutlet UILabel *chooseLab;


@end

@implementation GYHEShopFoodListKindOfTypeCell

- (void)awakeFromNib {
    _chooseLab.layer.cornerRadius = 11;
    _chooseLab.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
