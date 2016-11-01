//
//  GYHSPurchaseToolCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPurchaseToolCell.h"
#import <YYKit/UIImageView+YYWebImage.h>
#import "GYHSToolPurchaseModel.h"

@interface GYHSPurchaseToolCell()

@property (weak, nonatomic) IBOutlet UIImageView *toolImageView;
@property (weak, nonatomic) IBOutlet UILabel *toolNameLable;
@property (weak, nonatomic) IBOutlet UILabel *toolPriceTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *coinImageView;
@property (weak, nonatomic) IBOutlet UILabel *toolPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *toolNumLable;


@end
@implementation GYHSPurchaseToolCell
/**
 *  给各个控件设置属性
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    self.toolPriceTitleLable.textColor = kGray999999;
    self.toolPriceLable.textColor = kRedE50012;
}
/**
 *  给各个控件赋值
 */
- (void)setModel:(GYHSToolPurchaseModel *)model{
    _model = model;
    
    NSString *url = GY_PICTUREAPPENDING(model.microPic);
    [self.toolImageView setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionProgressiveBlur completion:nil];
    self.toolNameLable.text = model.productName;
    self.toolPriceLable.text = [GYUtils formatCurrencyStyle: model.price.doubleValue];
    self.toolNumLable.text = [NSString stringWithFormat:@"x%@",model.quanilty];
}

@end
