//
//  CellForMyOrderSubCell.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "CellForMyCouponsCell.h"

@implementation CellForMyCouponsCell

- (void)awakeFromNib
{
    [self.lbRow0 setTextColor:kValueRedCorlor];
    [self.lbRow1L setTextColor:kCellItemTextColor];
    [self.lbRow1R setTextColor:kCellItemTextColor];

    [self.lbRow2L setTextColor:kCellItemTextColor];
    [self.lbRow2R setTextColor:kCellItemTextColor];

    [self.lbRow3L setTextColor:kCellItemTextColor];
    [self.lbRow3R setTextColor:kCellItemTextColor];

    [self.lbRow4L setTextColor:kCellItemTextColor];
    [self.lbRow4R setTextColor:kCellItemTextColor];
    [GYUtils setFontSizeToFitWidthWithLabel:self.lbRow0 labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:self.lbRow4R labelLines:1];
    [self.lbRow1R addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeight
{
    return 130.0f;
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"text"] && object == self.lbRow1R) {
        [self setHsbLogoOffsetX:self.lbRow1R.text];
    }
}

- (void)setHsbLogoOffsetX:(NSString*)text
{
    NSString* str = text;
    CGSize strSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, self.lbRow1R.frame.size.width) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.lbRow1R.font } context:nil].size;
    CGRect iconRect = self.ivHsbLogo.frame;
    if (strSize.width <= self.lbRow1R.frame.size.width) {
        iconRect.origin.x = self.frame.size.width - kDefaultMarginToBounds - strSize.width - iconRect.size.width - 5; //距离文字5
        self.ivHsbLogo.frame = iconRect;
    } //else使用xib的布局
}

- (void)dealloc
{
    [self.lbRow1R removeObserver:self forKeyPath:@"text"];
}

@end
