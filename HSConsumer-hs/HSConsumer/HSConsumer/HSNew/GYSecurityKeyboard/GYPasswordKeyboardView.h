//
//  GYPasswordKeyboardView.h
//  GYText
//
//  Created by lizp on 16/9/5.
//  Copyright © 2016年 Apple05. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GYPasswordKeyboardStyle) {
    GYPasswordKeyboardStyleLogin, //登录类型
    GYPasswordKeyboardStyleTrading //交易类型
};

//登录类型中的键盘类型
typedef NS_ENUM(NSUInteger, GYPasswordKeyboardReturnType) {
    GYPasswordKeyboardReturnTypeConfirm, //确定
    GYPasswordKeyboardReturnTypeCommit, //提交
    GYPasswordKeyboardReturnTypeLogin //登录
};

//提交按钮的颜色
typedef NS_ENUM(NSUInteger, GYPasswordKeyboardCommitColorType) {
    GYPasswordKeyboardCommitColorTypeDefault, //默认 (互生 蓝色)
    GYPasswordKeyboardCommitColorTypeRed, // （互动 红色）
    GYPasswordKeyboardCommitColorTypeOrange // （互商 橘色色）
};

@class GYPasswordKeyboardView;
@protocol GYPasswordKeyboardViewDelegate <NSObject>

@optional

- (void)textFiledEdingChanged:(UITextField*)textField; //编辑中 输入数字的调用
- (void)returnPasswordKeyboard:(GYPasswordKeyboardView*)passwordKeyboard style:(GYPasswordKeyboardStyle)style type:(GYPasswordKeyboardReturnType)type password:(NSString*)password;
- (void)cancelClick; //  取消/返回时触发
- (void)returnCommitBtn:(UIButton*)button; //点击提交后，返回提交的button

//-(void)returnInputNumber:(NSString *)number;//返回输入的数字
//-(void)deleteNumber;//退格(回删数字)或者长按清除

@end

@interface GYPasswordKeyboardView : UIView

@property (nonatomic, assign) GYPasswordKeyboardStyle style;
@property (nonatomic, assign) GYPasswordKeyboardReturnType type;
@property (nonatomic, assign) GYPasswordKeyboardCommitColorType colorType;
@property (nonatomic, assign) BOOL isSecurity; //是否使用安全码（数字是否打乱）
@property (nonatomic, weak) id<GYPasswordKeyboardViewDelegate> delegate; //代理

/**
 *  弹出 
 *  参数：popView 加载到相应的视图上
 */
-(void)pop:(UIView *)popView;

/**
 *  消失
 */
-(void)dismiss;

/**
 *  设置输入源对象
 */
-(void)settingInputView:(UITextField *)inputView;

@end
