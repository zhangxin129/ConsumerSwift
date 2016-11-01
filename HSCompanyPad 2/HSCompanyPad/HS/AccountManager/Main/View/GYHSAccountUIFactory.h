//
//  GYHSCompanyAccountInputView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

//定义一个带有小图片和输入框的view
#import <UIKit/UIKit.h>

@class GYHSAccountUIFactory, GYTextField;
#import "GYTextField.h"
@protocol GYHSAccountUIFactoryDelegate <NSObject>
- (void)hsAccountUITurnToBankList:(GYHSAccountUIFactory *)cardViews;
@end

@interface GYHSAccountUIFactory : UIView
@property (nonatomic, weak) id<GYHSAccountUIFactoryDelegate> delegate;
@property (nonatomic, weak) GYTextField *textField;
@property (nonatomic, weak) UILabel *valueLabel;
@property (nonatomic, weak) UILabel *titleLabel;
/**
 *  生成一个前面带小图片,紧跟标题 后面带值 并传递颜色的视图
 *
 *  @param frame     边框尺寸
 *  @param imageName 图片名
 *  @param title     图片后的标题
 *  @param value     值
 *  @param color     值的颜色
 *
 *  @return 返回本视图
 */
- (instancetype)initKVImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title value:(NSString *)value valueColor:(UIColor *)color;


/**
 *  生成一个前面是标签 后面带输入框的
 *
 *  @param frame       边框尺寸
 *  @param words       标题
 *  @param placeholder 输入框的预留字
 *
 *  @return 返回本身视图
 */
- (instancetype)initInputViewWithFrame:(CGRect)frame title:(NSString *)words placeholder:(NSString *)placeholder;


/**
 *  生成一个输入8位密码的小方框
 *
 *  @param frame 边框尺寸
 *
 *  @return 返回自身视图
 */
- (instancetype)initPasswordViewWithFrame:(CGRect)frame;


/**
 *  生成左右两边各一个的标签
 *
 *  @param frame      边框尺寸
 *  @param title      标题
 *  @param value      值
 *  @param valueColor 值颜色
 *  @param isOKButton 是否在点OKButton后的
 *
 *  @return 返回自身视图
 */
- (instancetype)initKVCustomViewWithFrame:(CGRect)frame title:(NSString *)title value:(NSString *)value valueColor:(UIColor *)valueColor isOKButton:(BOOL)isOKButton;

//生成左右两边各一个的标签 后面用
- (instancetype)initImageValueViewWithFrame:(CGRect)frame imageName:(NSString *)imageName value:(NSString *)value;


/**
 *  生成一个温馨提示小方框
 *
 *  @param frame 边框尺寸
 *  @param tips  提示语
 */
- (void)initWithFrame:(CGRect)frame showTipsWords:(NSString *)tips;
//生成两句的温馨提示
- (void)initTwoTipsWithFrame:(CGRect)frame showTipsWords:(NSString *)tips andAnotherWords:(NSString *)tipsTwo;

/**
 *  生成三句温馨提示的小方框
 *
 *  @param frame     边框尺寸
 *  @param tipsOne   提示语1
 *  @param tipsTwo   提示语2
 *  @param tipsThree 提示语3
 */
- (void)initWithFrame:(CGRect)frame showTipsWordsOne:(NSString *)tipsOne tipsWordsTwo:(NSString *)tipsTwo tipsWordsThree:(NSString *)tipsThree;


/**
 *  创建一个 类似中国银行 尾号多少多少字样的通用视图
 *
 *  @param imageName    银行logo
 *  @param title        标题
 *  @param bankCardType 银行账户类型
 *  @param value        值
 */
- (void)initBankCardViewWithImageName:(NSString *)imageName title:(NSString *)title bankCardType:(NSString *)bankCardType value:(NSString *)value;

/**
 *  封装银行账户 其他银行账户 箭头类型的view
 *
 *  @param frame  边框尺寸
 *  @param title  标题
 *  @param value  值
 *  @param isBlue 是否蓝色
 *
 *  @return 返回自身视图
 */
- (instancetype)initChooseViewWithFrame:(CGRect)frame title:(NSString *)title value:(NSString *)value smallArrowColor:(BOOL)isBlue;


@end
