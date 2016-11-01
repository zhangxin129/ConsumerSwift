//
//  GYQRCodeReaderDelegate.h
//  HSCompanyPad
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSCodeReaderViewController;

@protocol GYHSCodeReaderDelegate <NSObject>

@optional

#pragma mark - Listening for Reader Status
/*!
 *    扫描
 *
 *    @param reader 扫描器
 *    @param result 扫描的数据
 */
- (void)reader:(GYHSCodeReaderViewController*)reader didScanResult:(NSString*)result;

/*!
 *    撤销扫描
 *
 *    @param reader 扫描器
 */
- (void)readerDidCancel:(GYHSCodeReaderViewController*)reader;

@end
