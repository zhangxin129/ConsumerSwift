//
//  GYHEShopGoodListCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopGoodListCell.h"

@interface GYHEShopGoodListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *pvLab;
@property (weak, nonatomic) IBOutlet UILabel *postLab;
@property (weak, nonatomic) IBOutlet UILabel *couponLab;
@property (weak, nonatomic) IBOutlet UIView *couponView;

@property (weak, nonatomic) IBOutlet UIView *serverView;

@end

@implementation GYHEShopGoodListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(GYHEShopDetailGoodListModel *)model {
    _model = model;
    
    [_imgV setImageWithURL:[NSURL URLWithString:model.pics.firstObject[@"p200x200"]] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
    _titleLab.text = kSaftToNSString(model.name);
//    _introduceLab.text =
    _priceLab.text = [NSString stringWithFormat:@"%.2f",[kSaftToNSString(model.price) doubleValue]];
    _pvLab.text = [NSString stringWithFormat:@"%.2f",[kSaftToNSString(model.pv) doubleValue]];
//    _postLab.text =
    if(model.coupon.count > 0) {
        _couponView.hidden = NO;
        GYHEShopDetailGoodCouponModel *coup = model.coupon.firstObject;
        _couponLab.text = [NSString stringWithFormat:@"满%@使用%@元抵扣券%@张",kSaftToNSString(coup.amount),kSaftToNSString(coup.faceValue),kSaftToNSString(coup.num)];
    }else {
        _couponView.hidden = YES;
    }
    
//    _serverView =
}

@end
