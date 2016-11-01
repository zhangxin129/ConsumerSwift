//
//  ViewOrderStateInfo.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewOrderStateInfo.h"

@interface ViewOrderStateInfo ()

@end

@implementation ViewOrderStateInfo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    NSArray* subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    ViewOrderStateInfo* v = [subviewArray objectAtIndex:0];
    [v.lbState setTextColor:kCorlorFromHexcode(0xFA3C28)];
    v.lbState.font = [UIFont systemFontOfSize:14];
    [v.lbOrderNo setTextColor:kCorlorFromHexcode(0x5A5A5A)];
    v.lbOrderNo.font = [UIFont systemFontOfSize:14];
    [v.lbOrderDatetime setTextColor:kCorlorFromHexcode(0x5A5A5A)];
    v.lbOrderDatetime.font = [UIFont systemFontOfSize:14];
    [v.lbOrderTakeCode setTextColor:kCorlorFromHexcode(0x5A5A5A)];
    v.lbOrderTakeCode.font = [UIFont systemFontOfSize:14];
    v.clipsToBounds = YES;
    return v;
}

+ (CGFloat)getHeight
{
    return 115.0f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self addTopBorderAndBottomBorder];
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
    // Drawing code
   }
 */

@end
