/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "GYQRCodeReaderDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

/**
 * The `QRCodeReaderViewController` is a simple QRCode Reader/Scanner based on
 * the `AVFoundation` framework from Apple. It aims to replace ZXing or ZBar
 * for iOS 7 and over.
 */
@interface GYQRCodeReaderViewController : UIViewController

#pragma mark - Managing the Delegate
/** @name Managing the Delegate */

/**
 * @abstract The object that acts as the delegate of the receiving QRCode
 * reader.
 * @since 1.0.0
 */
@property (nonatomic, weak) id<GYQRCodeReaderDelegate> delegate;



#pragma mark - Checking the Metadata Items Types
/** @name Checking the Metadata Items Types */

/**
 * @abstract Returns whether you can scan a QRCode with the current device.
 * @return a Boolean value indicating whether you can scan a QRCode with the current device.
 */
+ (BOOL)isAvailable;

/** @name Controlling the Reader */

/**
 * @abstract Starts scanning the codes.
 * @since 3.0.0
 */
- (void)startScanning;

/**
 * @abstract Stops scanning the codes.
 * @since 3.0.0
 */
- (void)stopScanning;

#pragma mark - Managing the Block
/** @name Managing the Block */

/**
 * @abstract Sets the completion with a block that executes when a QRCode or when the user did
 * stopped the scan.
 * @param completionBlock The block to be executed. This block has no return value and takes
 * one argument: the `resultAsString`. If the user stop the scan and that there is no response
 * the `resultAsString` argument is nil.
 * @since 1.0.1
 */
- (void)setCompletionWithBlock:(void (^)(NSString* resultAsString))completionBlock;

@end
