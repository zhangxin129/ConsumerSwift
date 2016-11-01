//
//  GYAccounTradeAlertView.m
//  HSConsumer
//
//  Created by ios007 on 15/12/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  账户交易提示框的封装View

#import "GYAccounTradeAlertView.h"

@interface GYAccounTradeAlertView () {

    buttonClickBlock _buttonClickBlock;
}
//账户交易提醒框
@property (nonatomic, strong) UIWindow* alertWindow;
@property (nonatomic, strong) UIView* coverBackView;

@end

@implementation GYAccounTradeAlertView

#pragma mark - 懒加载

- (UIWindow*)alertWindow
{

    if (!_alertWindow) {

        UIWindow* window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        window.backgroundColor = [UIColor clearColor];
        window.windowLevel = UIWindowLevelNormal;
        window.alpha = 1.0f;
        window.hidden = NO;
        _alertWindow = window;
    }
    return _alertWindow;
}

- (UIView*)coverBackView
{

    if (!_coverBackView) {

        UIView* coverView = [[UIView alloc] init];
        coverView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        coverView.backgroundColor = kCorlorFromRGBA(0, 0, 0, 0.3);
        _coverBackView = coverView;
    }
    return _coverBackView;
}

- (GYAccounTradeConfirmAlertView*)alertViewAccounTradeConfirm
{

    if (!_alertViewAccounTradeConfirm) {

        GYAccounTradeConfirmAlertView* alertV = [GYAccounTradeConfirmAlertView alertView];
        _alertViewAccounTradeConfirm = alertV;
    }
    return _alertViewAccounTradeConfirm;
}

- (GYAccounTradeResultAlertView*)alertViewAccounTradeResult
{

    if (!_alertViewAccounTradeResult) {

        GYAccounTradeResultAlertView* alertV = [GYAccounTradeResultAlertView alertView];
        _alertViewAccounTradeResult = alertV;
    }
    return _alertViewAccounTradeResult;
}

#pragma mark -GYAccounTradeConfirmAlertView
/**
 *  弹出简单的交易前确认框，有“取消”和“确定”按钮。需设置GYAccounTradeConfirmAlertView(类)控件的属性
 */
- (void)showAccounTradeConfirmAlertView
{

    //1.添加蒙版
    [self.alertWindow addSubview:self.coverBackView];

    //2.添加提示框
    [self.alertWindow addSubview:self.alertViewAccounTradeConfirm];

    self.alertViewAccounTradeConfirm.alpha = 0.0;
    CGFloat alertVX = 20;
    CGFloat alertVY = kScreenHeight * 1 / 3;
    CGFloat alertVW = kScreenWidth - 2 * alertVX;
    CGFloat alertVH = 150;
    self.alertViewAccounTradeConfirm.frame = CGRectMake(alertVX, alertVY, alertVW, alertVH);
    [UIView animateWithDuration:0.35 animations:^{

        self.alertViewAccounTradeConfirm.alpha = 1.0;

    }];

    [self.alertViewAccounTradeConfirm setButtonClick_TransAttributeContentText_Block:^(NSInteger buttonIndex) {

        if (buttonIndex == kCancelBtnClickIndex) {

            [self accounTradeAlertViewDismiss];
            if (_buttonClickBlock) {

                _buttonClickBlock(kCancelBtnClickIndex);

            }

        } else if (buttonIndex == kConfirmBtnClickIndex) {

            [self accounTradeAlertViewDismiss];
            if (_buttonClickBlock) {

                _buttonClickBlock(kConfirmBtnClickIndex);

            }
        }

    }];
}

/**
 *  弹出简单的交易前确认框，有“取消”和“确定”按钮。需传入contentText参数来简单设置正文的内容alertContentLabel.text
 *  @param: contentText
 */
- (void)showAccounTradeConfirmAlertViewWithcontentText:(NSString*)contentText
{

    //1.添加蒙版
    [self.alertWindow addSubview:self.coverBackView];

    //2.添加提示框
    [self.alertWindow addSubview:self.alertViewAccounTradeConfirm];

    self.alertViewAccounTradeConfirm.alpha = 0.0;
    if ([contentText isKindOfClass:[NSNull class]]) {
        contentText = @"";
    }
    self.alertViewAccounTradeConfirm.contentText = contentText;
    CGFloat alertVX = 20;
    CGFloat alertVY = kScreenHeight * 1 / 3;
    CGFloat alertVW = kScreenWidth - 2 * alertVX;
    CGFloat alertVH = 150;
    self.alertViewAccounTradeConfirm.frame = CGRectMake(alertVX, alertVY, alertVW, alertVH);
    [UIView animateWithDuration:0.35 animations:^{

        self.alertViewAccounTradeConfirm.alpha = 1.0;

    }];

    [self.alertViewAccounTradeConfirm setButtonClickBlock:^(NSInteger buttonIndex) {


        if (buttonIndex == kCancelBtnClickIndex) {

            [self accounTradeAlertViewDismiss];
            if (_buttonClickBlock) {

                _buttonClickBlock(kCancelBtnClickIndex);

            }

        } else if (buttonIndex == kConfirmBtnClickIndex) {

            [self accounTradeAlertViewDismiss];
            if (_buttonClickBlock) {

                _buttonClickBlock(kConfirmBtnClickIndex);

            }
        }

    }];
}

#pragma mark -GYAccounTradeResultAlertView
/**
 *  弹出交易后结果确认框，有确定”按钮。需设置GYAccounTradeResultAlertView(类)控件的属性
 */
- (void)showAccounTradeResultAlertView
{

    //1.添加蒙版
    [self.alertWindow addSubview:self.coverBackView];

    //2.添加提示框
    [self.alertWindow addSubview:self.alertViewAccounTradeResult];

    self.alertViewAccounTradeResult.alpha = 0.0;
    CGFloat alertVX = 20;
    CGFloat alertVY = kScreenHeight * 1 / 3;
    CGFloat alertVW = kScreenWidth - 2 * alertVX;
    CGFloat alertVH = 150;
    self.alertViewAccounTradeResult.frame = CGRectMake(alertVX, alertVY, alertVW, alertVH);
    [UIView animateWithDuration:0.35 animations:^{

        self.alertViewAccounTradeResult.alpha = 1.0;

    }];

    [self.alertViewAccounTradeResult setButtonClick_TransAttributeContentText_Block:^(NSInteger buttonIndex) {

        if (buttonIndex == kConfirmBtnClickIndex) {

            [self accounTradeAlertViewDismiss];
            if (_buttonClickBlock) {

                _buttonClickBlock(kConfirmBtnClickIndex);

            }
        }
    }];
}

/**
 *  弹出简单的交易后结果确认框，有确定”按钮。需传入contentText参数和contentDetailTex(可为空)参数来简单设置正文的内容alertContentLabel.text和正文详细信息内容alertContentDetailLabel.text
 *  @param: contentText,contentDetailTex
 */
- (void)showAccounTradeResultAlertViewWithSuccess:(BOOL)isSuccess contentText:(NSString*)contentText contentDetailText:(NSString*)contentDetailText
{

    //1.添加蒙版
    [self.alertWindow addSubview:self.coverBackView];

    //2.添加提示框
    [self.alertWindow addSubview:self.alertViewAccounTradeResult];

    self.alertViewAccounTradeResult.alpha = 0.0;
    //self.alertViewAccounTradeResult.success = isSuccess;
    if ([contentText isKindOfClass:[NSNull class]]) {
        contentText = @"";
    }
    self.alertViewAccounTradeResult.contentText = contentText;
    if ([contentDetailText isKindOfClass:[NSNull class]]) {
        contentDetailText = @"";
    }
    self.alertViewAccounTradeResult.contentDetailText = contentDetailText;
    CGFloat alertVX = 20;
    CGFloat alertVY = kScreenHeight * 1 / 3;
    CGFloat alertVW = kScreenWidth - 2 * alertVX;
    CGFloat alertVH = 150;
    self.alertViewAccounTradeResult.frame = CGRectMake(alertVX, alertVY, alertVW, alertVH);
    [UIView animateWithDuration:0.35 animations:^{

        self.alertViewAccounTradeResult.alpha = 1.0;

    }];

    [self.alertViewAccounTradeResult setButtonClickBlock:^(NSInteger buttonIndex) {


        if (buttonIndex == kConfirmBtnClickIndex) {

            [self accounTradeAlertViewDismiss];
            if (_buttonClickBlock) {

                _buttonClickBlock(kConfirmBtnClickIndex);

            }
        }

    }];
}

#pragma mark -提示框消失
- (void)accounTradeAlertViewDismiss
{

    if (_coverBackView) {
        [self.coverBackView removeFromSuperview];
        _coverBackView = nil;
    }

    if (_alertViewAccounTradeResult) {
        [self.alertViewAccounTradeResult removeFromSuperview];
        _alertViewAccounTradeResult = nil;
    }

    if (_alertViewAccounTradeConfirm) {
        [self.alertViewAccounTradeConfirm removeFromSuperview];
        _alertViewAccounTradeConfirm = nil;
    }

    if (_alertWindow) {
        _alertWindow.hidden = YES;
        _alertWindow = nil;
    }

    [self removeFromSuperview];

}

#pragma mark - 按钮点击回调
- (void)setButtonClickBlock:(buttonClickBlock)buttonClickBlock {

    _buttonClickBlock = buttonClickBlock;
}

@end
