//
//  GYShopInfoWithLocationCell.m
//  HSConsumer
//
//  Created by Apple03 on 15-5-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopInfoWithLocationCell.h"
#import "UIView+Extension.h"
@interface GYShopInfoWithLocationCell ()

@property (weak, nonatomic) IBOutlet UIImageView* phoneImageView;
@end

@implementation GYShopInfoWithLocationCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    //添加上面的分割线
    CALayer* topLayer = [CALayer layer];
    topLayer.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"gyhe_line_confirm_dialog_yellow"]] CGColor];
    topLayer.frame = CGRectMake(self.frame.origin.x + 16, 5, CGRectGetWidth(self.frame), 1);
    [self.layer addSublayer:topLayer];

    self.lbHsNumber.textColor = kCellItemTitleColor;
    self.lbHsNumber.backgroundColor = [UIColor clearColor];
    self.lbShopAddress.textColor = kCellItemTextColor;
    self.lbDistance.textColor = kCellItemTextColor;
    [self.btnPhoneCall setTitleColor:kCellItemTextColor forState:UIControlStateNormal];

    [self.btnCheckMap setTitle:kLocalized(@"GYHE_SurroundVisit_LookMap") forState:UIControlStateNormal];

    [self.btnCheckMap setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    self.imgvMapIcon.image = [UIImage imageNamed:@"gyhe_map_shopdetail_map"];
    [self.imgvSeproter addRightBorder];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.phoneImageView.y = self.btnPhoneCall.y;

}

@end
