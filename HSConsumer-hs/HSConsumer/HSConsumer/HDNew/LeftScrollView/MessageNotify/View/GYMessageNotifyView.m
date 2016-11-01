//
//  GYMessageNotifyView.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMessageNotifyView.h"
#import "Masonry.h"

@interface GYMessageNotifyView ()

@end

@implementation GYMessageNotifyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)];
        [self addGestureRecognizer:tap];
        

    }
    return self;
}
- (void)showWithVc:(UIViewController *)vc {
    
    UIViewController *windowVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    [windowVC.view addSubview:self];
    
    _showView = [[UIView alloc] initWithFrame:CGRectMake(42, (kScreenHeight- 176)/2.0, kScreenWidth - 84, 176)];
    _showView.backgroundColor = [UIColor whiteColor];
    _showView.layer.cornerRadius = 10;
    _showView.clipsToBounds = YES;
    [windowVC.view addSubview:_showView];
    
    [windowVC addChildViewController:vc];
    [self.showView addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.showView);
    }];
    
}
- (void)dissmiss {
    [_showView removeFromSuperview];
    [self removeFromSuperview];
    
}


@end
