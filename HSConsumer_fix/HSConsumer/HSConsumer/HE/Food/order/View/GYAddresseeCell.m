//
//  GYAddresseeCell.m
//  HSConsumer
//
//  Created by 00 on 14-12-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddresseeCell.h"

@implementation GYAddresseeCell
- (IBAction)btnChangeADClick:(id)sender
{
    [self.delegate pushSelAddrVC];
}

//点击支付按钮，创建支付选择页面
- (IBAction)btnSelPayWayClick:(id)sender
{

    DDLogDebug(@"进入支付方式选中页面");

    NSMutableArray* mArrData;

    if (globalData.loginModel.cardHolder) {
        mArrData = [NSMutableArray arrayWithObjects:kLocalized(@"GYHE_Food_ArriveAndPay"), kLocalized(@"GYHE_Food_NetBankToPay"), kLocalized(@"GYHE_Food_HSBAccountPay"),
                                   nil];
    }
    else {
        mArrData = [NSMutableArray arrayWithObjects:kLocalized(@"GYHE_Food_ArriveAndPay"), kLocalized(@"GYHE_Food_NetBankToPay"),
                                   nil];
    }

    [self.delegate pushSelWayVCWithmArray:mArrData WithIndexPath:self.indexPath];
}

- (void)awakeFromNib
{

    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.btnChangeAddress setTitle:kLocalized(@"GYHE_Food_PleaseSelectReceiveAddress") forState:UIControlStateNormal];
    [self.btnChangeAddress setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    self.lbPhone.adjustsFontSizeToFitWidth = YES;
    //    self.lbAddressee.adjustsFontSizeToFitWidth = YES;
    self.rightArrow.frame = CGRectMake(self.rightArrow.frame.origin.x, (self.frame.size.height - self.rightArrow.frame.size.height) / 2, self.rightArrow.frame.size.width, self.rightArrow.frame.size.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self.lbLine addTopBorder];
//    [self addAllBorder];
}

@end
