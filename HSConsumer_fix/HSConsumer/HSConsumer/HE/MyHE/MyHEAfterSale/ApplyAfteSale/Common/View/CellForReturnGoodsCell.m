//
//  CellForReturnGoodsCell.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "CellForReturnGoodsCell.h"

@interface CellForReturnGoodsCell ()

@property (nonatomic, assign) BOOL isSelected;

@end

@implementation CellForReturnGoodsCell

- (void)awakeFromNib
{
    // Initialization code
    [self.lbGoodsName setTextColor:kCellItemTitleColor];
    [self.lbGoodsPrice setTextColor:kNavigationBarColor];
    [GYUtils setFontSizeToFitWidthWithLabel:self.lbGoodsName labelLines:2];
    _isSelected = NO;
    [self.btnSelect setImage:kLoadPng(@"gycommon_circular_unselected_gray") forState:UIControlStateNormal];
    [self.btnSelect addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)selectClick:(id)sender
{
    _isSelected = !_isSelected;
    if (_isSelected) {
        [sender setImage:kLoadPng(@"gycommon_circular_selected_red") forState:UIControlStateNormal];
    }
    else {
        [sender setImage:kLoadPng(@"gycommon_circular_unselected_gray") forState:UIControlStateNormal];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectChange:)]) {
        [_delegate selectChange:self];
    }
}

- (BOOL)isSelected
{
    return _isSelected;
}

+ (CGFloat)getHeight
{
    return 80.0f;
}

@end
