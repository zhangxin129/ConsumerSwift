//
//  GYHSServerDetailFooter.m
//  HSConsumer
//
//  Created by zhengcx on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSServerDetailFooter.h"
#import "UIButton+GYExtension.h"
#import "GYHSServerDetailAllModel.h"

@implementation GYHSServerDetailFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = kBackgroundGrayColor;
        // 1.查看物流 按钮
        UIButton* lookLogisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lookLogisterBtn.frame = CGRectMake(kScreenWidth - 240, 3, 70, 35);
        [lookLogisterBtn setBorderWithWidth:1.0 andRadius:2.0 andColor:kCorlorFromHexcode(0x666666)];
        [lookLogisterBtn setBackgroundColor:kCorlorFromHexcode(0xffffff)];
        [lookLogisterBtn setTitleColor:kCorlorFromHexcode(0x333333) forState:UIControlStateNormal];
        lookLogisterBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.lookLogisterBtn.layer.cornerRadius = 8;
        self.lookLogisterBtn.layer.masksToBounds = YES;
        [lookLogisterBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [self addSubview:lookLogisterBtn];
        [lookLogisterBtn addTarget:self action:@selector(lookLogisterBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.lookLogisterBtn = lookLogisterBtn;
        // 2.售后申请 按钮
        UIButton* afterSaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        afterSaleBtn.frame = CGRectMake(kScreenWidth - 163, 3, 70, 35);
        [afterSaleBtn setBorderWithWidth:1.0 andRadius:2.0 andColor:kCorlorFromHexcode(0x666666)];
        [afterSaleBtn setBackgroundColor:kCorlorFromHexcode(0xffffff)];
        [afterSaleBtn setTitleColor:kCorlorFromHexcode(0x333333) forState:UIControlStateNormal];
        afterSaleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.afterSaleBtn.layer.cornerRadius = 8;
        self.afterSaleBtn.layer.masksToBounds = YES;
        [afterSaleBtn setTitle:@"售后申请" forState:UIControlStateNormal];
        [self addSubview:afterSaleBtn];
        [afterSaleBtn addTarget:self action:@selector(afterSaleBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.afterSaleBtn = afterSaleBtn;
        // 3.退款申请 按钮
        UIButton* requestBackPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        requestBackPayBtn.frame = CGRectMake(kScreenWidth - 85, 3, 70, 35);
        [requestBackPayBtn setBorderWithWidth:1.0 andRadius:2.0 andColor:kCorlorFromHexcode(0xff5000)];
        [requestBackPayBtn setTitleColor:kCorlorFromHexcode(0xff5000) forState:UIControlStateNormal];
        [requestBackPayBtn setBackgroundColor:kCorlorFromHexcode(0xffffff)];
        requestBackPayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.requestBackPayBtn.layer.cornerRadius = 8;
        self.requestBackPayBtn.layer.masksToBounds = YES;
        [requestBackPayBtn setTitle:@"退款申请" forState:UIControlStateNormal];
        [self addSubview:requestBackPayBtn];
        [requestBackPayBtn addTarget:self action:@selector(requestBackPayBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.requestBackPayBtn = requestBackPayBtn;
        // 4.再订 按钮
        UIButton* buyAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyAgainBtn.frame = CGRectMake(kScreenWidth - 85, 3, 70, 35);
        [buyAgainBtn setBorderWithWidth:1.0 andRadius:2.0 andColor:kCorlorFromHexcode(0xff5000)];
        [buyAgainBtn setTitleColor:kCorlorFromHexcode(0xff5000) forState:UIControlStateNormal];
        [buyAgainBtn setBackgroundColor:kCorlorFromHexcode(0xffffff)];
        buyAgainBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.buyAgainBtn.layer.cornerRadius = 8;
        self.buyAgainBtn.layer.masksToBounds = YES;
        [buyAgainBtn setTitle:@"再订" forState:UIControlStateNormal];
        [self addSubview:buyAgainBtn];
        [buyAgainBtn addTarget:self action:@selector(buyAgainBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.buyAgainBtn = buyAgainBtn;

        [self allBtnHidden];
    }
    return self;
}

- (void)allBtnHidden
{
    //    self.lookLogisterBtn.hidden = YES;
    //    self.afterSaleBtn.hidden = YES;
    self.requestBackPayBtn.hidden = YES;
}

//查看物流
- (void)lookLogisterBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lookLogisterBtn:)]) {

        [self.delegate lookLogisterBtn:self];
    }
}

//退款申请
- (void)requestBackPayBtnAction
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(requestBackPayBtn:)]) {

        [self.delegate requestBackPayBtn:self];
    }
}

//售后申请
- (void)afterSaleBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(afterSaleBtn:)]) {

        [self.delegate afterSaleBtn:self];
    }
}

//再订
- (void)buyAgainBtnBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyAgainBtn:)]) {
        [self.delegate buyAgainBtn:self];
    }
}

@end
