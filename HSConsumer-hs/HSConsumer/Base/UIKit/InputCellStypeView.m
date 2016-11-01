//
//  InputCellStypeView.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "InputCellStypeView.h"

@implementation InputCellStypeView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        DDLogDebug(@"int0");
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.lbLeftlabel setTextColor:kCellItemTitleColor];
    [self.tfRightTextField setTextColor:kCellItemTitleColor];

    [self.lbLeftlabel setFont:kDefaultFont];
    [self.tfRightTextField setFont:kDefaultFont];
    [GYUtils setPlaceholderAttributed:self.tfRightTextField withSystemFontSize:17 withColor:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addTopBorder];
    [self addBottomBorder];
}

@end
