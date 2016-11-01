//
//  UIViewTwoButton.h
//  HSCompanyPad
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYKeyboardTwoButtonViewDelegate <NSObject>

-(void)keyboardTwoButtonViewFirstClick;
-(void)keyboardTwoButtonViewSecondClick:(UIButton*)button;

@end

/*!
 *  键盘的右边：确定和一个按钮
 */
@interface GYKeyboardTwoButtonView : UIView

- (instancetype)initWithTitle:(NSString*)titleName;

@property (nonatomic, weak) id<GYKeyboardTwoButtonViewDelegate> delegate;

@end
