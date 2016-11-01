//
//  GYHSHsbRightView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/9/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

typedef NS_ENUM (NSUInteger, kHSBAccountTouchEvent)
{
    kHSBAccountTouchEventDetail      = 1,//查询明细
    kHSBAccountTouchEventHsbToCash   = 2,//互生币转货币
    kHSBAccountTouchEventExchangeHsb = 3,//兑换互生币
};
#import <UIKit/UIKit.h>
#import "GYHSAccountCenter.h"
@class GYHSHsbRightView;
@protocol GYHSHsbRightViewDelegate <NSObject>
@optional
/**
 *  代理方法 互生币右边键盘点击的代理方法
 *
 *  @param hsbView 自身视图
 *  @param event   事件类型
 */
- (void)hsbView:(GYHSHsbRightView *)hsbView didTouchEvent:(kHSBAccountTouchEvent)event;

@end
@interface GYHSHsbRightView : UIView
@property (nonatomic, weak) id<GYHSHsbRightViewDelegate> delegate;
@property (nonatomic, strong) GYHSAccountCenter *data;

@end
