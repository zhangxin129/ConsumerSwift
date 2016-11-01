//
//  GYHEShopFoodsListFooterView.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopFoodsListFooterView.h"
#import "Masonry.h"


@interface GYHEShopFoodsListFooterView()

@property (strong, nonatomic) IBOutlet UIView *selectedView;
@property (strong, nonatomic) IBOutlet UIView *unSelectedView;


@property (weak, nonatomic) IBOutlet UIView *selectedHeaderView;
@property (weak, nonatomic) IBOutlet UIView *unSelectedHeaderView;

@property (weak, nonatomic) IBOutlet UIView *canNotBuyView;
@property (weak, nonatomic) IBOutlet UIButton *canBuyBtn;


@end

@implementation GYHEShopFoodsListFooterView

- (void)awakeFromNib {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCart)];
    
    _selectedHeaderView.layer.cornerRadius = 22;
    _selectedHeaderView.clipsToBounds = YES;
    [_selectedHeaderView addGestureRecognizer:tap];
    _unSelectedHeaderView.layer.cornerRadius = 22;
    _unSelectedHeaderView.clipsToBounds = YES;

    _countLab.layer.cornerRadius = 7;
    _countLab.clipsToBounds = YES;
}
- (void)showCart {
    if([self.delegate respondsToSelector:@selector(showCart:)]) {
        [self.delegate showCart:self];
    }
}

- (void)updateType:(GYFoodFooterType)type {
    if(type == _type) {
        return ;
    }
    
    if(type == GYUnSelectedFoodFooterType) {
        for(UIView *v in self.subviews) {
            [v removeFromSuperview];
        }
        [self addSubview:_unSelectedView];
        [_unSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        
        
    }else if(type == GYSelectedFoodFooterType){
        for(UIView *v in self.subviews) {
            [v removeFromSuperview];
        }
        [self addSubview:_selectedView];
        [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
    }else if (type == GYSelectedFoodFooterType) {
        for(UIView *v in self.subviews) {
            [v removeFromSuperview];
        }
        [self addSubview:_selectedView];
        [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
    }
    _type = type;
}
- (void)setFreeShippingPrice:(CGFloat)freeShippingPrice {
    _freeShippingPrice = freeShippingPrice;
    _canBuyBtn.hidden = NO;
    _canNotBuyView.hidden = YES;
}
- (IBAction)buyNow:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(payNow:)]) {
        [self.delegate payNow:self];
    }
}

@end
