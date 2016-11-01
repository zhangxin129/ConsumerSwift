//
//  GYShopFoodDetailView.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopFoodDetailView.h"
#import "Masonry.h"

@implementation GYShopFoodDetailView

- (instancetype)init {
    self = [super init];
    if(self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)createViewWithVC:(UIViewController *)vc {
    _vc = vc;
    
    UIViewController *windowVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    [windowVC.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];

    
    UIView *detailView = [[UIView alloc] init];
    [windowVC.view addSubview:detailView];
    _detailView = detailView;
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(kScreenWidth / 720.0 * 490);
    }];
    
    [windowVC addChildViewController:vc];
    [_detailView addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}
- (void)setVc:(UIViewController *)vc {
    if(vc && _vc) {
        [_vc.view removeFromSuperview];
        [_vc removeFromParentViewController];
    }
    
    if(vc) {
        _vc = vc;
        
        UIViewController *windowVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        [windowVC addChildViewController:vc];
        [_detailView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];

    }
    
}

- (void)dismissView {
    [self removeFromSuperview];
    [_detailView removeFromSuperview];
    [_vc.view removeFromSuperview];
    [_vc removeFromParentViewController];
}

@end
