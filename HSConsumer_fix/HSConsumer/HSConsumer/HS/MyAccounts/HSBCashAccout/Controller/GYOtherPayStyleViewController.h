//
//  GYOtherPayStyleViewController.h
//  HSConsumer
//
//  Created by apple on 15/12/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  选择其他支付方式

#import "GYViewController.h"
#import "GYQRPayModel.h"

typedef NS_ENUM(NSInteger, PayStyleCurrent) {
    payStyleWithQuickPayment = 0,
    payStyleWithUnionpay = 1,
    payStyleWithCurrency = 2
};

typedef NS_ENUM(NSInteger, GYFunctionType) {
    GYFunctionTypeWithBuyHSB = 50,
    GYFunctionTypeWithReApplyCard,
    GYFunctionTypeWithQRPay,
    GYFunctionTypeWithGoods,
    GYFunctionTypeWithFood
};

@interface GYOtherPayStyleViewController : GYViewController

@property (nonatomic, assign) double inputValue; //传过来的交易值
@property (nonatomic, copy) NSString* transNo; //传过来的流水号
@property (nonatomic, assign) PayStyleCurrent currentPayStyle; //当前选中的值
@property (nonatomic, assign) GYFunctionType currentFunctionType;
@property (nonatomic, strong) GYQRPayModel* model;
@property (nonatomic, strong) NSDate *date;

/**
 * 上一个页面传过来的navigationItem.title
 */
@property (nonatomic, assign) NSString *tradeTitle;
@end
