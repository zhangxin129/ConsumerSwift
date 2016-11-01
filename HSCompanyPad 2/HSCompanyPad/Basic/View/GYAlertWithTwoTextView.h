//
//  GYAlertWithTwoTextView.h
//
//  Created by apple on 16/8/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYAlertWithTwoTextView;
typedef void(^GYAlertBlock)(NSString *, NSString *);
/*!
 *    带输入框的提示框
 */

@protocol GYAlertTextViewDelegate <NSObject>

- (void)transPassword:(NSString *)password;
- (void)transAlertView:(GYAlertWithTwoTextView *)alertView CardNum:(NSString *)cardNum Password:(NSString *)password;

@end

@interface GYAlertWithTwoTextView : UIView

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, strong) UIButton *leftbtn;
@property (nonatomic, strong) UIButton *rightbtn;
@property (nonatomic, copy) GYAlertBlock rightBlock;
@property (nonatomic, weak) id<GYAlertTextViewDelegate> delegate;
@property (nonatomic, strong) UITextField *userNameTextField;

- (id)initWithTitle:(NSString *)title
userNameTF:(NSString *)userName
passWordTF:(NSString*)passWord
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;

- (void)show;

@end
                                                