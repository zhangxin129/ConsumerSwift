//
//  GYPadKeyboradView.h
//  test
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYPadKeyboradViewDelegate <NSObject>

- (void)padKeyBoardViewDidClickNumberWithString:(NSString *)string;
- (void)padKeyBoardViewDidClickDelete;

@end

/*!
 *    键盘视图
 */
@interface GYPadKeyboradView : UIView

@property (nonatomic, weak) id<GYPadKeyboradViewDelegate> delegate;

@end
