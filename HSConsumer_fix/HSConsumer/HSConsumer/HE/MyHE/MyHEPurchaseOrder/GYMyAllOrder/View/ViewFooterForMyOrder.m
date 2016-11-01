//
//  ViewFooterForMyOrder.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewFooterForMyOrder.h"
#import "UIButton+GYExtension.h"

@implementation ViewFooterForMyOrder
//追加国际化 add zhangx
- (void)awakeFromNib
{

    self.backPVLabel.text = kLocalized(@"GYHE_MyHE_RefundPV");
    [self.backPVLabel setTextColor:kCorlorFromHexcode(0x8C8C8C)];
    self.backPVLabel.font = [UIFont systemFontOfSize:14];
    self.backPVLabel.hidden = YES;

    [self.lbLabelMoney setTextColor:kCorlorFromHexcode(0x8C8C8C)];
    self.lbLabelMoney.text = kLocalized(@"GYHE_MyHE_RealPays");
    self.lbLabelMoney.font = [UIFont systemFontOfSize:14];
    [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_BuyAgain") forState:UIControlStateNormal];

    [self.btn0 setTitle:kLocalized(@"GYHE_MyHE_ApplyAfterSales") forState:UIControlStateNormal];

    [self.deliverBtn setTitle:kLocalized(@"GYHE_MyHE_DeliverGoods") forState:UIControlStateNormal];
    [self.deliverBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [self.deliverBtn setBorderWithWidth:1.0 andRadius:2.0 andColor:kCorlorFromRGBA(250, 60, 40, 1)];
    self.deliverBtn.hidden = YES;
}

- (id)init
{
    NSArray* subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    id v = [subviewArray objectAtIndex:0];
    return v;
}

+ (CGFloat)getHeight
{
    return 75.0f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self addTopBorderAndBottomBorder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
