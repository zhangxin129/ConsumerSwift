//
//  GYAroundShopsCategorySectionView.m
//  HSConsumer
//
//  Created by Apple03 on 15/11/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAroundShopsCategorySectionView.h"
#import "GYAroundShopsCategoryButton.h"
#import "GYAroundShopsCategoryModel.h"

@interface GYAroundShopsCategorySectionView ()
@property (nonatomic, weak) UILabel* lbTitle;
@property (nonatomic, weak) GYAroundShopsCategoryButton* btnChoose;
@property (nonatomic, weak) GYAroundShopsCategoryButton* btnShowAll;
@property (nonatomic, weak) UIImageView* imvArrow;
@end

@implementation GYAroundShopsCategorySectionView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat btnWidth = kScreenWidth - 140;
    CGFloat btnHeight = self.frame.size.height;
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, btnWidth, btnHeight)];
    lbTitle.textColor = kCellItemTitleColor;
    lbTitle.contentMode = UIViewContentModeCenter;
    lbTitle.textAlignment = NSTextAlignmentLeft;
    lbTitle.font = [UIFont systemFontOfSize:17];
    lbTitle.backgroundColor = [UIColor clearColor];
    [self addSubview:lbTitle];
    self.lbTitle = lbTitle;

    GYAroundShopsCategoryButton* btnChoose = [GYAroundShopsCategoryButton buttonWithType:UIButtonTypeCustom];
    btnChoose.backgroundColor = [UIColor clearColor];
    btnChoose.frame = lbTitle.frame;
    [btnChoose addTarget:self action:@selector(chooseSection:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnChoose];

    GYAroundShopsCategoryButton* btnShowAll = [GYAroundShopsCategoryButton buttonWithType:UIButtonTypeCustom];
    btnShowAll.backgroundColor = [UIColor clearColor];
    [btnShowAll setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    btnShowAll.titleLabel.font = [UIFont systemFontOfSize:13];
    btnShowAll.frame = CGRectMake(CGRectGetMaxX(lbTitle.frame), 0, kScreenWidth - btnWidth, btnHeight);
    [btnShowAll addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnShowAll];
    self.btnShowAll = btnShowAll;

    UIImageView* imvArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycommon_cell_btn_right"]];
    CGFloat imvWidth = 12;
    CGFloat imvHeight = 20;
    imvArrow.frame = CGRectMake(kScreenWidth - imvWidth - 20, 0, imvWidth, imvHeight);
    imvArrow.center = CGPointMake(imvArrow.center.x, btnShowAll.center.y);
    [self addSubview:imvArrow];
    self.imvArrow = imvArrow;
}

- (void)chooseSection:(GYAroundShopsCategoryButton*)sender
{
    DDLogDebug(@"choose section %zi", self.index);
    self.chooseBlock(self.index);
}

- (void)showAll:(GYAroundShopsCategoryButton*)sender
{
    DDLogDebug(@"showAll section %zi", self.index);
    self.ShowBlock(self.index);
}

- (void)setViewWithData:(GYAroundShopsCategoryModel*)model
{
    self.categoryModel = model;
    if ([model.categoryName hasPrefix:kLocalized(@"GYHE_SurroundVisit_All")]) {
        self.imvArrow.hidden = NO;
        [self.btnShowAll setTitle:@"" forState:UIControlStateNormal];
        self.lbTitle.text = @"";
        self.lbTitle.text = model.categoryName;
    }
    else {
        self.imvArrow.hidden = YES;
        [self.btnShowAll setTitle:kLocalized(@"GYHE_SurroundVisit_CheckAll") forState:UIControlStateNormal];
        self.lbTitle.text = model.categoryName;
    }
}

@end
