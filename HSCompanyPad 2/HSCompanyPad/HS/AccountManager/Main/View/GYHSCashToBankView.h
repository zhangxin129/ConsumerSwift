//
//  GYHSCoinToBankLeftView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYTextField.h"
@class GYHSCashToBankView, GYHSBankListModel, GYHSAccountUIFactory;
@protocol GYHSCashToBankViewDelegate <NSObject>
/**
 *  代理方法 点击进入其他银行的页面
 *
 *  @param cashView 自身视图
 */
- (void)cashToBankViewDidClickSelectedBankAccount:(GYHSCashToBankView *)cashView;

@end

@interface GYHSCashToBankView : UIView
@property (nonatomic, weak) id<GYHSCashToBankViewDelegate> delegate;
@property (nonatomic, copy) NSString *cashBalance;
@property (nonatomic, strong) GYTextField *turnOutTf;
@property (nonatomic, strong) GYTextField *passWordTf;
@property (nonatomic, strong) GYHSBankListModel *model;
@property (nonatomic, strong) GYTextField *originTurnOutTf;
@property (nonatomic, weak) GYHSAccountUIFactory *addBankCardView;
/**
 *  生成带银行账户的左边视图
 */
- (void)initCommanView;
/**
 *  生成没有默认银行账户需要点箭头处理的左边视图
 */
- (void)initNoCardView;
@end
