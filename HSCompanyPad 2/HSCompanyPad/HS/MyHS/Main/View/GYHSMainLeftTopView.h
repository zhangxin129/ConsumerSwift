//
//  GYHSMainLeftTopView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSMyHSMainModel;
@interface GYHSMainLeftTopView : UIView
/*!
 *    箭头图标的点击事件
 */
@property(nonatomic, copy) dispatch_block_t bigImageBlock;
/*!
 *    点击头像的事件
 */
@property(nonatomic, copy) dispatch_block_t tapHeadLogoBlock;

@end
