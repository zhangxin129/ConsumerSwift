//
//  GYHSMainRightTopView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSMyHSMainModel;


typedef void(^ActivityBlock)(BOOL isJoin);


@interface GYHSMainRightTopView : UIView
/*!
 *    停止积分活动点击事件
 */
@property (nonatomic, copy) ActivityBlock stopActivityBlock;
/*!
 *    停止积分活动点击事件
 */
@property (nonatomic, copy) ActivityBlock joinActivityBlock;
/*!
 *    注销系统事件
 */
@property (nonatomic, copy) dispatch_block_t logoutSystemBlock;
/*!
 *     去认证点击事件
 */
@property (nonatomic, copy) ActivityBlock toAuthenticateBlock;
/*!
 *    去缴纳年费事件
 */
@property (nonatomic, copy) dispatch_block_t toPayYearFeeBlock;

/*!
 *    model
 */
@property (nonatomic, strong) GYHSMyHSMainModel* model;


@end
