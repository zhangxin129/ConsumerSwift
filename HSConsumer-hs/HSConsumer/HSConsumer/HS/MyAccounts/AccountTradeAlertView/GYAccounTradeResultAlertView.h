//
//  GYAccounTradeResultAlertView.h
//  HSConsumer
//
//  Created by ios007 on 15/12/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  账户交易结果提示（提示框账户转换交易或失败或失败带失败原因）

#import <UIKit/UIKit.h>

#define kConfirmBtnClickIndex 2
typedef void (^buttonClickBlock)(NSInteger buttonIndex);

@interface GYAccounTradeResultAlertView : UIView

/**
 *  提示正文内容（成功或者失败）
 */
@property (weak, nonatomic) IBOutlet UILabel* alertContentLabel;

/**
 *  提示正文内容具体原因    积分账户可用积分数不足100
 */
@property (weak, nonatomic) IBOutlet UILabel* alertContentDetailLabel;

/**
 *  提示正文下面的横线
 */
@property (weak, nonatomic) IBOutlet UIView* alertContentBottomLineView;

/**
 *  确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton* confirmBtn;

/**
 *  弹出交易后结果确认框，有确定”按钮。不需传入参数，有外部修改本类控件的属性
 */
- (void)setButtonClick_TransAttributeContentText_Block:(buttonClickBlock)buttonClick_TransAttributeContentText_Block;

//------------------------------------------------------------------------------
/**
 *  提示内容
 */
@property (nonatomic, weak) NSString* contentText;

/**
 *  提示内容详情（提示失败原因）
 */
@property (nonatomic, weak) NSString* contentDetailText;

/**
 *  弹出简单的交易后结果确认框，有确定”按钮。需设置contentText参数和contentDetailTex(可为空)t参数来简单设置正文的内容alertContentLabel.text和正文详细信息内容alertContentDetailLabel.text
 *  @param: contentText,contentDetailTex
 */
- (void)setButtonClickBlock:(buttonClickBlock)buttonClickBlock;



+ (instancetype)alertView;
@end
