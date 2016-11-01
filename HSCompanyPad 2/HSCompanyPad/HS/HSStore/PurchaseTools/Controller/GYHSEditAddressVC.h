//
//  GYHSEditAddressVC.h
//
//  Created by apple on 16/8/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"

typedef NS_ENUM(NSUInteger, GYHSEditAddressVCType)
{
    GYHSEditAddressVCTypeAdd ,//添加
    GYHSEditAddressVCTypeChange //修改
    
};
@class GYHSAddressListModel;

@interface GYHSEditAddressVC: GYBaseViewController


@property (nonatomic, strong) GYHSAddressListModel *model;
@property (nonatomic, assign) GYHSEditAddressVCType type;

@end
