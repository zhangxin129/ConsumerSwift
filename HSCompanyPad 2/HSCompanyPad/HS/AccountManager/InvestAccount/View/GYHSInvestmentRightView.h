//
//  GYHSInvestmentRightView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/9/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
typedef NS_ENUM (NSUInteger, kInvestmentAccountTouchEvent)
{
    kInvestmentRateTouchEvent      = 1,//历年投资回报率
    kInvestmentDetailTouchEvent    = 2, //投资明细查询
    kDividendDetailQueryTouchEvent = 3, //分红明细
};
#import <UIKit/UIKit.h>
#import "GYHSAccountCenter.h"
@class GYHSInvestmentRightView;
@protocol GYHSInvestmentRightViewDelegate <NSObject>
@optional
/**
 *  根据点击情况处理点击事件
 *
 *  @param investmentView 自身视图
 *  @param event          事件类型
 */
- (void)investmentView:(GYHSInvestmentRightView *)investmentView didTouchEvent:(kInvestmentAccountTouchEvent)event;

@end
@interface GYHSInvestmentRightView : UIView
@property (nonatomic, weak) id<GYHSInvestmentRightViewDelegate> delegate;
@property (nonatomic, strong) GYHSAccountCenter *data;
@end
