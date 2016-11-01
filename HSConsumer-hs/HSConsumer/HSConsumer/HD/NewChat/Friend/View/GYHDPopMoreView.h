//
//  GYHDPopMoreView.h
//  HSConsumer
//
//  Created by shiang on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectMessageBlock)(NSString* message);

@interface GYHDPopMoreView : UIView
/**
 *  显示
 */
- (void)show;
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
