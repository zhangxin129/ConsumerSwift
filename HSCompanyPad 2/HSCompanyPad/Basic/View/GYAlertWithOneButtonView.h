//
//  GYAlertWithOneButtonView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *    单个确定按钮的视图
 */
@interface GYAlertWithOneButtonView : UIView

+ (GYAlertWithOneButtonView*)alertWithMessage:(NSString*)message topColor:(TopColor)topColor comfirmBlock:(dispatch_block_t)block;

@end
