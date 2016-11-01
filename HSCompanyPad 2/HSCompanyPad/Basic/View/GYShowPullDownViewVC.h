//
//  GYShowPullDownView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//


/*!
 *    控制器需要全局拥有
 *
 */

#import <Foundation/Foundation.h>

typedef void (^PullBlock)(NSInteger index);

@interface GYShowPullDownViewVC : UIPopoverController
/*!
 *    创建并弹出一个控制器视图
 *
 *    @param view       显示在附近view
 *    @param titleArray 弹出视图的数据
 *    @param direction  相对view的方向
 *
 *    @return 控制器视图
 */
- (instancetype)initWithView:(UIView*)view PullDownArray:(NSArray<NSString*>*)titleArray direction:(UIPopoverArrowDirection)direction;
/*!
 *    点击事件
 */
@property (nonatomic, copy) PullBlock selectBlock;

@end
