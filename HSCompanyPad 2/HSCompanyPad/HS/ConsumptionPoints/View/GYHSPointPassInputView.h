//
//  GYHSPointPassInputView.h
//
//  Created by apple on 16/8/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, kPasswordType) {
    kPasswordTrade = 1,//交易密码
    kPasswordLogin = 2,//登录密码
};
@interface GYHSPointPassInputView : UIView
@property (nonatomic,strong) UITextField * passField;
- (instancetype)initWithFrame:(CGRect)frame type:(kPasswordType)type;

@end
                                                