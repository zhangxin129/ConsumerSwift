//
//  GYHSCashRightView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/9/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
typedef NS_ENUM (NSUInteger, kCashAccountTouchEvent)
{
    kCashAccountTouchEventDetail     = 1,//查询明细
    kCashAccountTouchEventCashToBank = 2,//货币转银行
};
#import <UIKit/UIKit.h>
#import "GYHSAccountCenter.h"


@class GYHSCashRightView;
@protocol GYHSCashRightViewDelegate <NSObject>
@optional
/**
 *  带键盘视图右边点击的代理方法
 *
 *  @param cashView 右边自身视图
 *  @param event    事件类型
 */
- (void)cashView:(GYHSCashRightView *)cashView didTouchEvent:(kCashAccountTouchEvent)event;
@end

@interface GYHSCashRightView : UIView
@property (nonatomic, weak) id<GYHSCashRightViewDelegate> delegate;

@property (nonatomic, strong) GYHSAccountCenter *data;
@end
