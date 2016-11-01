//
//  GYHSCompanyToHSBAndInvestmentVC.h
//
//  Created by 吴文超 on 16/8/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GYBaseViewController.h"
/**
 *    @业务标题 :
 *
 *    @Created :吴文超
 *    @Modify  : 1.将前面制作的积分转互生币和积分投资两个带键盘界面的控制器合并到一起 左边是显示状态 右边是键盘结构
 *               2.
 *               3.
 */
typedef NS_ENUM (NSUInteger, kPointMoveType)
{
    kPointTransformHSB = 1, //积分转互生币
    kPointInvestment   = 2 //积分投资
};
@interface GYHSCompanyToHSBAndInvestmentVC : GYBaseViewController
@property (nonatomic, assign) kPointMoveType vcType;
@end
