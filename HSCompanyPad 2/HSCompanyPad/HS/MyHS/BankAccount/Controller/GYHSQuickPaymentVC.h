//
//  GYHSQQuickPaymentVC.h
//
//  Created by apple on 16/8/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"
/**
 *    @业务标题 :快捷卡支付界面
 *
 *    @Created :@liangxh
 *    @Modify  : 1.
 *               2.
 *               3.
 */
@class GYHSQuickListModel;
@protocol GYHSSelectQuickBankDelegate <NSObject>

- (void)selectQuickBankWithModel:(GYHSQuickListModel *)model;

@end

@interface GYHSQuickPaymentVC: GYBaseViewController
@property (nonatomic,weak) id<GYHSSelectQuickBankDelegate> delegate;

@end
