//
//  GYHDPopMoreView.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectMessageBlock)(NSString* message);

@interface GYHDPopMoreView : UIView

/**
 *  显示
 */
- (void)showBottomTo:(UIView *)view;
/**
 *  隐藏
 */
- (void)disMiss;
/**
 *  更多选项
 */
@property (nonatomic, strong) NSArray* moreSelectArray;
/**
 *  选择回调
 */
@property (nonatomic, copy) selectMessageBlock block;

@end
