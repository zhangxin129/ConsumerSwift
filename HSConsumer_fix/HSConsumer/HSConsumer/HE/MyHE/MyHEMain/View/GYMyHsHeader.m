//
//  GYMyHsHeader.m
//  HSConsumer
//
//  Created by apple on 15/8/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMyHsHeader.h"
#import "UIButton+GYExtension.h"

@implementation GYMyHsHeader

- (void)awakeFromNib
{
    self.image = [UIImage imageNamed:@"gyhe_myhe_hsBackground"];
    [GYUtils setFontSizeToFitWidthWithLabel:self.lbLastLoginTime labelLines:1];
    UIImage* image = kLoadPng(@"gyhe_myhe_nav_back");
    CGRect backframe = CGRectMake(15, 30, image.size.width * 0.5, image.size.height * 0.5);
    self.userInteractionEnabled = YES;
    [self addSubview:self.btnBackToRoot];
    self.btnBackToRoot.frame = backframe;
    [self.btnBackToRoot setBackgroundImage:image forState:UIControlStateNormal];

    self.btnBackToRoot.layer.masksToBounds = YES;
    self.btnBackToRoot.layer.cornerRadius = 6;

    self.LbUserHello.text = kLocalized(@"GYHE_MyHE_HeLLo");
    self.LbUserHello.text = [NSString stringWithFormat:@"%@, %@", kLocalized(@"GYHE_MyHE_HeLLo"), globalData.loginModel.resNo];

    self.lbLastLoginTime.text = [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_MyHE_LastLoginTime"), globalData.loginModel.lastLoginDate ? globalData.loginModel.lastLoginDate : @""];

    self.myHSLabel.text = kLocalized(@"GYHE_MyHE_MyHE");

    [self reloadHeader];
    self.headerImgView.layer.cornerRadius = 35;
    self.headerImgView.layer.borderWidth = 2;
    self.headerImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerImgView.clipsToBounds = YES;
}

- (void)reloadHeader
{
    NSString* imgUrl = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, globalData.loginModel.headPic];
    [self.headerImgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:kLoadPng(@"hs_cell_img_noneuserimg") options:kNilOptions completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.btnBackToRoot setEnlargEdgeWithTop:10 right:30 bottom:10 left:25];
}

- (UIButton*)btnBackToRoot
{
    if (!_btnBackToRoot) {
        _btnBackToRoot = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btnBackToRoot;
}

- (void)btnBackToRootClicked:(UIButton*)btn
{
}

@end
