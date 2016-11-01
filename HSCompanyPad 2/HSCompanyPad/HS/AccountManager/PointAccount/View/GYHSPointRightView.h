//
//  GYHSPointRightView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/9/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
typedef NS_ENUM (NSUInteger, kPointAccountTouchEvent)
{
    kPointAccountTouchEventDetail        = 1,//查询明细
    kPointAccountTouchEventPointToHsb    = 2,//积分转互生币
    kPointAccountTouchEventPointToInvest = 3 //积分投资
};
#import <UIKit/UIKit.h>
#import "GYHSAccountCenter.h"
@class GYHSPointRightView;
@protocol GYHSPointRightViewDelegate <NSObject>
@optional
/**
 *  积分账户下点击处理事件
 *
 *  @param pointView 积分账户自身视图
 *  @param event     事件类型
 */
- (void)pointView:(GYHSPointRightView *)pointView didTouchEvent:(kPointAccountTouchEvent)event;
@end

@interface GYHSPointRightView : UIView
@property (nonatomic, weak) id<GYHSPointRightViewDelegate> delegate;
@property (nonatomic, strong) GYHSAccountCenter *data;


@end
