//
//  GYSurroundGoodsMenuCell.m
//  HSConsumer
//
//  Created by Apple03 on 15/11/13.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYSurroundGoodsMenuCell.h"
#import "GYSurroundGoodsMenuModel.h"
#import "UIView+CustomBorder.h"

//cell主题灰色的字体颜色
#define kTitleColor kCorlorFromRGBA(70, 70, 70, 1)
#define kTitleFont [UIFont systemFontOfSize:13];

@interface GYSurroundGoodsMenuCell ()

@property (nonatomic, weak) UILabel* lbTitle;
@property (nonatomic, weak) UIView* vRed;

@end

@implementation GYSurroundGoodsMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UILabel* titleLab = [[UILabel alloc] init];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kTitleFont;
    titleLab.numberOfLines = 1;
    [self.contentView addSubview:titleLab];
    self.lbTitle = titleLab;

    UIView* vRed = [[UIView alloc] init];
    vRed.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:vRed];
    self.vRed = vRed;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)refreshWithModel:(GYSurroundGoodsMenuModel*)model
{
    self.lbTitle.text = model.categoryName;
    if (model.isSelected) {
        self.vRed.hidden = NO;
        self.lbTitle.textColor = [UIColor redColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.vRed.hidden = YES;
        self.lbTitle.textColor = kTitleColor;
        self.contentView.backgroundColor = kCorlorFromRGBA(238, 238, 238, 1);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.vRed.frame = CGRectMake(0, 0, 2, self.frame.size.height);
    self.lbTitle.frame = CGRectMake(CGRectGetMaxX(self.vRed.frame), 0, self.frame.size.width - CGRectGetMaxX(self.vRed.frame) - 2, self.frame.size.height);
    [self.contentView addBottomBorder];
    [self.contentView addRightBorder];
    [self.contentView addTopBorder];
}

@end
