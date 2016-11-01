//
//  GYQRCodeReaderViewController.h
//  HSCompanyPad
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYBaseViewController.h"
#import "GYCodeReaderDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface GYHSCodeReaderViewController : GYBaseViewController

#pragma mark - Managing the Delegate
/*!
 *    代理
 */
@property (nonatomic, weak) id<GYHSCodeReaderDelegate> delegate;

#pragma mark - Checking the Metadata Items Types
/*!
 *    判断是否有扫描功能（摄像头等等）
 *
 *    @return BOOL
 */
+ (BOOL)isAvailable;

/*!
 *    开始扫描
 */
- (void)startScanning;

/*!
 *    停止扫描
 */
- (void)stopScanning;

#pragma mark - Managing the Block
/*!
 *    扫描完成
 *
 *    @param completionBlock block
 */
- (void)setCompletionWithBlock:(void (^)(NSString* resultAsString))completionBlock;

@end
