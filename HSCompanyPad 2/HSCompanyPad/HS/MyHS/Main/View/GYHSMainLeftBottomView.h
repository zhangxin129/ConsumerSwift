//
//  GYHSMainLeftBottomView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSMyHSMainModel;

@interface GYHSMainLeftBottomView : UIView
/*!
 *    model
 */
@property (nonatomic, strong) GYHSMyHSMainModel* model;
/*!
 *    联系人点击事件
 */
@property (nonatomic, copy) dispatch_block_t linkmanBlock;
/*!
 *    邮箱事件
 */
@property (nonatomic, copy) dispatch_block_t emailBlock;
/*!
 *    银行卡点击事件
 */
@property (nonatomic, copy) dispatch_block_t bankCardBlock;
/*!
 *    快捷卡点击事件
 */
@property (nonatomic, copy) dispatch_block_t quickCardBlock;

@end
