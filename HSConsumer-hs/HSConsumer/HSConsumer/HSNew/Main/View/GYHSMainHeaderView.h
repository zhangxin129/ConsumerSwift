//
//  GYHSMainHeaderView.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSMainHeaderViewDelegate <NSObject>

- (void)sweepCodePayAction:(UIButton*)button;
- (void)paymentCodeAction:(UIButton*)button;
- (void)integralCodeAction:(UIButton*)button;
- (void)exchangeHSMoneyAction:(UIButton*)button;

@end

@interface GYHSMainHeaderView : UIView

@property (nonatomic, weak) id<GYHSMainHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *sweepCodePayView;
@property (weak, nonatomic) IBOutlet UIView *paymentCodeView;
@property (weak, nonatomic) IBOutlet UIView *integralCodeView;
@property (weak, nonatomic) IBOutlet UIView *exchangeHSMoneyView;

- (void)resetSelectFlag:(NSInteger)flag;

@end
