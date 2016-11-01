//
//  ViewHeaderForMyOrder.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewHeaderForMyOrder.h"

@implementation ViewHeaderForMyOrder

- (id)init
{

    NSArray* subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    id v = [subviewArray objectAtIndex:0];
    return v;
}

+ (CGFloat)getHeight
{
    return 61.0f;
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
    // Drawing code
   }
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addTopBorderAndBottomBorder];


}

@end
