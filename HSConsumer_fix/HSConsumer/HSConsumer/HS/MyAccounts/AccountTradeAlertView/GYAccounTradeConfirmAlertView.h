//
//  GYAccounTradeConfirmAlertView.h
//  HSConsumer
//
//  Created by ios007 on 15/12/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  账户交易提示（提示框账户交易信息确认）

#import <UIKit/UIKit.h>

#define kCancelBtnClickIndex 1
#define kConfirmBtnClickIndex 2
typedef void (^buttonClickBlock)(NSInteger buttonIndex);

@interface GYAccounTradeConfirmAlertView : UIView

/**
 *  正文内容Label  确认要申请积分转互生币吗？
 */
@property (weak, nonatomic) IBOutlet UILabel* alertContentLabel;

/**
 *  提示正文下面的横线
 */
@property (weak, nonatomic) IBOutlet UIView* alertContentBottomLineView;

/**
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton* cancelBtn;

/**
 *  确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton* confrimBtn;

/**
 *  弹出交易后结果确认框，有确定”按钮。不需传入参数，有外部修改本类控件的属性
 */
- (void)setButtonClick_TransAttributeContentText_Block:(buttonClickBlock)buttonClick_TransAttributeContentText_Block;

/**
 *  正文内容
 */
@property (nonatomic, weak) NSString* contentText;

/**
 *  弹出简单的交易前确认框，有“取消”和“确定”按钮。需设置contentText参数来简单设置正文的内容alertContentLabel.text
 *  @param: contentText
 */
- (void)setButtonClickBlock:(buttonClickBlock)buttonClickBlock;

+ (instancetype) alertView;

@end
