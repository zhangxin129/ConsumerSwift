//
//  GYHSAccountKeyBoard.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSUInteger, kAccountKeyBoardType)
{
    kAccountKeyBoardTypePointToHSB    = 1,//键盘结构积分转互生币
    kAccountKeyBoardTypePointToInvest = 2,//键盘结构积分投资
    kAccountKeyBoardTypeHSBToCash     = 3,//键盘结构互生币转货币
    kAccountKeyBoardTypeCashToBank    = 4 //键盘结构货币转银行
};

typedef NS_ENUM (NSUInteger, kAccountKeyBoardButtonEvent)
{
    kAccountKeyBoardButtonEventShowDetail = 1, //按钮点击查询明细
    kAccountKeyBoardButtonEventSwitch     = 2, //按钮点击类型界面
    kAccountKeyBoardButtonEventOK         = 3, //按钮点击OK按钮
};

@protocol GYHSAccountKeyBoardDelegate <NSObject>
@required
- (void)padKeyBoardViewDidClickNumberWithString:(NSString *)string;//标准键盘添加字符
- (void)padKeyBoardViewDidClickDelete;//标准键盘删除字符
/**
 *  处理事件类型
 *
 *  @param event 事件类型
 */
- (void)padKeyBoardViewDidClickEvent:(kAccountKeyBoardButtonEvent)event;
@end

@interface GYHSAccountKeyBoard : UIView
@property (nonatomic, weak) id<GYHSAccountKeyBoardDelegate> delegate;
@property (nonatomic, strong) UIButton *clickOKBtn;
@property (nonatomic, assign) kAccountKeyBoardType type;
@end
