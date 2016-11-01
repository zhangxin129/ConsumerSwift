//
//  GYHSQueryToolMidCell.m
//  HSCompanyPad
//
//  Created by User on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSQueryToolMidCell.h"
#import "GYHSStoreQueryDetailModel.h"

@interface GYHSQueryToolMidCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;//工具照片

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//工具名称

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//工具价格

@property (weak, nonatomic) IBOutlet UILabel *numLabel;//工具数量
@end

@implementation GYHSQueryToolMidCell

- (void)awakeFromNib {
    
    self.nameLabel.textColor = kGray333333;
    self.priceLabel.textColor = kRedE40011;
    self.numLabel.textColor = kGray333333;
}

- (void)setModel:(GYHSStoreConfsModel *)model{
    _model = model;
    if ([model.categoryCode isEqualToString:@"P_CARD"] || [model.productName isEqualToString:kLocalized(@"GYHS_HSStore_Query_HSCard")]) {//消费者资源段特殊处理
        _nameLabel.text = kLocalized(@"GYHS_HSStore_Query_SegmentConsumerSystemsResources");
        _priceLabel.text  = [NSString stringWithFormat:@"%@",[GYUtils formatCurrencyStyle:model.price.doubleValue * GYPerSegmentHsCardCount]];
        _numLabel.text = [NSString stringWithFormat:@"x%@",[@((self.model.quantity.integerValue + 1 ) / GYPerSegmentHsCardCount) stringValue]];
    }else {
        _nameLabel.text = model.productName;
        _priceLabel.text = [NSString stringWithFormat:@"%@",[GYUtils formatCurrencyStyle :model.price.doubleValue]];
        _numLabel.text = [NSString stringWithFormat:@"x%@",model.quantity];
    }
    [_imgView  setImageWithURL:[NSURL URLWithString:GY_PICTUREAPPENDING(model.productPic)] placeholder:[UIImage imageNamed:@"placeholder_image"] options:YYWebImageOptionShowNetworkActivity completion:nil];
}
@end
