//
//  GYAccounTradeConfirmAlertView.m
//  HSConsumer
//
//  Created by ios007 on 15/12/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  账户交易提示（提示框账户交易信息确认）

#import "GYAccounTradeConfirmAlertView.h"

@interface GYAccounTradeConfirmAlertView () {
    buttonClickBlock _buttonClickBlock;
}

@end

@implementation GYAccounTradeConfirmAlertView

- (void)awakeFromNib
{
    [self.cancelBtn setTitle:kLocalized(@"GYHS_MyAccounts_cancel") forState:UIControlStateNormal];
    [self.confrimBtn setTitle:kLocalized(@"GYHS_MyAccounts_sure") forState:UIControlStateNormal];
    self.confrimBtn.backgroundColor = kNavigationBarColor;
    self.cancelBtn.layer.cornerRadius = 5.0f; //圆角半径

    self.cancelBtn.layer.masksToBounds = YES; //圆角
    self.cancelBtn.layer.borderWidth = 0.5f; //边框宽度
    self.cancelBtn.layer.borderColor = [[UIColor grayColor] CGColor]; //边框颜色

    self.confrimBtn.layer.cornerRadius = 5.0f; //圆角半径
    self.confrimBtn.layer.masksToBounds = YES; //圆角
    self.confrimBtn.layer.borderWidth = 0.5f; //边框宽度
    self.confrimBtn.layer.borderColor = [[UIColor grayColor] CGColor]; //边框颜色
}

+ (instancetype)alertView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYAccounTradeConfirmAlertView class]) owner:self options:nil] lastObject];
}

/**
 *  弹出简单的交易前确认框，有“取消”和“确定”按钮。需设置contentText参数来简单设置正文的内容alertContentLabel.text
 *
 *  @param: contentText
 */
- (void)setButtonClickBlock:(buttonClickBlock)buttonClickBlock
{
    _buttonClickBlock = buttonClickBlock;
    self.alertContentLabel.text = self.contentText;
}

/**
 *  弹出交易后结果确认框，有确定”按钮。不需传入参数，有外部修改本类控件的属性
 */
- (void)setButtonClick_TransAttributeContentText_Block:(buttonClickBlock)buttonClick_TransAttributeContentText_Block
{
    _buttonClickBlock = buttonClick_TransAttributeContentText_Block;
}

//取消按钮点击响应
- (IBAction)cancelBtn:(id)sender {
    if (_buttonClickBlock) {
        _buttonClickBlock(kCancelBtnClickIndex);
    }
}

//确定按钮点击响应
- (IBAction)confrimBtn:(id)sender {
    if (_buttonClickBlock) {
        _buttonClickBlock(kConfirmBtnClickIndex);
    }
}

@end
