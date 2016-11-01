//
//  GYHECollectionGoodCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHECollectionGoodCell.h"

@implementation GYHECollectionGoodCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GYHECollectListModel *)model
{
    _model  = model;
    NSMutableArray *array  =[[NSMutableArray alloc] init];
    if (model.servicesInfo.hasSerCoupon){
        [array addObject:[UIImage imageNamed:@"gyhe_good_detail5"]];
    }
    if (model.servicesInfo.hasSerDeposit){
        [array addObject:[UIImage imageNamed:@"gyhe_food_main_order"]];
    }
    if (model.servicesInfo.hasSerTakeout){
        [array addObject:[UIImage imageNamed:@"gyhe_good_detail2"]];
    }
    if (array.count >0) {
        for (NSInteger i=0; i<array.count; i++) {
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconView.frame.size.width -18*(i+1), 0, 16, 16)];
            iconImage.image = array[i];
            [self.iconView addSubview:iconImage];
        }
    }
    pics *p = model.pics[0];
   [self.picURLImageView setImageWithURL:[NSURL URLWithString:p.p400x400] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
    if(model.name.length > 15){//截取最大显示的个数
        self.nameLb.text = [model.name substringToIndex:15];
    }else{
        self.nameLb.text = model.name;
    }
    self.priceLb.text = model.priceLow;
    self.integralLb.text = model.pvLow;
    if (model.postage) {
        self.freightLb.text = [NSString stringWithFormat:@"运费：%@",model.postage];
    }else{
        self.freightLb.text = @"免运费";
    }
}
@end
