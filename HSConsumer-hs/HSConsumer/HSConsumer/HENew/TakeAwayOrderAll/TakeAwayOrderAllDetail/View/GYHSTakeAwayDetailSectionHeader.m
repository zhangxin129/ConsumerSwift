//
//  GYHSTakeAwayDetailSectionHeader.m
//  HSConsumer
//
//  Created by kuser on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSTakeAwayDetailSectionHeader.h"
#import "GYHSTakeAwayDetailAllModel.h"

@implementation GYHSTakeAwayDetailSectionHeader

- (void)awakeFromNib
{
    self.shopNameLabel.textColor = kCorlorFromHexcode(0x333333);
    self.shopNameLabel.font = [UIFont systemFontOfSize:14];
    self.connectLabel.textColor = kCorlorFromHexcode(0x333333);
    self.connectLabel.font = [UIFont systemFontOfSize:12];
}

- (void)setModel:(GYHSTakeAwayDetailAllModel*)model
{
    _model = model;
    self.shopNameLabel.text = model.shopName;
}

//联系客服
- (IBAction)contactCompanyClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedContactBtn:)]) {
        [self.delegate didSelectedContactBtn:self];
    }
}

//进入商铺详情
- (IBAction)intoShopClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedIntoShopBtn:)]) {
        [self.delegate didSelectedIntoShopBtn:self];
    }
}

@end
