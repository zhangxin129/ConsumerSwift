//
//  GYAccounTradeResultAlertView.m
//  HSConsumer
//
//  Created by ios007 on 15/12/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  账户交易结果提示（提示框账户转换交易或失败或失败带失败原因）

#import "GYAccounTradeResultAlertView.h"

@interface GYAccounTradeResultAlertView () {
    buttonClickBlock _buttonClickBlock;
}

@end

@implementation GYAccounTradeResultAlertView

- (void)awakeFromNib
{
    //self.alertTitleLabel.text=kLocalized(@"fd_order_All_Prompt");
    [self.confirmBtn setTitle:kLocalized(@"GYHS_MyAccounts_sure") forState:UIControlStateNormal];
    self.confirmBtn.layer.cornerRadius = 5.0f; //圆角半径
    self.confirmBtn.backgroundColor = kNavigationBarColor;

    self.confirmBtn.layer.masksToBounds = YES; //圆角

    self.confirmBtn.layer.borderWidth = 0.5f; //边框宽度

    self.confirmBtn.layer.borderColor = [[UIColor grayColor] CGColor]; //边框颜色
}

#pragma mark - 加载xib
+ (instancetype)alertView
{

    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYAccounTradeResultAlertView class]) owner:nil options:nil] lastObject];
}

#pragma mark - init

- (id)initWithCoder:(NSCoder*)aDecoder
{

    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

/**
 *  弹出简单的交易后结果确认框，有确定”按钮。需设置contentText参数和contentDetailTex(可为空)t参数来简单设置正文的内容alertContentLabel.text和正文详细信息内容alertContentDetailLabel.text
 *  @param: contentText,contentDetailTex
 */
- (void)setButtonClickBlock:(buttonClickBlock)buttonClickBlock
{

    _buttonClickBlock = buttonClickBlock;

    self.alertContentLabel.text = self.contentText;
    self.alertContentLabel.adjustsFontSizeToFitWidth = YES;
    self.alertContentDetailLabel.text = self.contentDetailText;
    if ([self.contentDetailText isEqualToString:@""] || self.contentDetailText == nil) {

        self.alertContentDetailLabel.hidden = YES;
    }
    else {

        self.alertContentDetailLabel.hidden = NO;
    }
}

/**
 *  弹出交易后结果确认框，有确定”按钮。不需传入参数，有外部修改本类控件的属性
 */
- (void)setButtonClick_TransAttributeContentText_Block:(buttonClickBlock)buttonClick_TransAttributeContentText_Block
{

    _buttonClickBlock = buttonClick_TransAttributeContentText_Block;


    self.alertContentDetailLabel.hidden = YES;


}

#pragma mark - 确认按钮响应事件
- (IBAction)confirmBtn:(id)sender {


    if (_buttonClickBlock) {

        _buttonClickBlock(kConfirmBtnClickIndex);

    }


}

@end
