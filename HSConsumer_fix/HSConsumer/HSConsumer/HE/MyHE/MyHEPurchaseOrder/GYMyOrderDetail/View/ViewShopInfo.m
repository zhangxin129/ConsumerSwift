//
//  ViewShopInfo.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewShopInfo.h"

@interface ViewShopInfo ()

@end

@implementation ViewShopInfo

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
    ViewShopInfo* v = [subviewArray objectAtIndex:0];
    [v.lbShopAddress setTextColor:kCorlorFromHexcode(0xA0A0A0)];
    v.lbShopAddress.font = [UIFont systemFontOfSize:14];
    [v.btnShopTel setTitleColor:kCorlorFromHexcode(0xA0A0A0) forState:UIControlStateNormal];
    v.btnShopTel.titleLabel.font = [UIFont systemFontOfSize:14];
    
    v.btnShopTel.imageEdgeInsets = UIEdgeInsetsMake(1, 0, 1, 156);
    v.btnShopTel.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 60);
    [v.telLabel setTextColor:kCorlorFromHexcode(0xA0A0A0)];
    v.telLabel.text = [NSString stringWithFormat:@"电话:"];
    v.telLabel.font = [UIFont systemFontOfSize:14];
    [GYUtils setFontSizeToFitWidthWithLabel:v.lbShopAddress labelLines:2];
    return v;
}

+ (CGFloat)getHeight
{
    return 80.0f;
    //    return 68.0f;
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
