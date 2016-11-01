//
//  GYAddAddressSroViewController.h
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  新增收货地址  &&  收货地址管理1

#import <UIKit/UIKit.h>
#import "GYAddressModel.h"
#import "GYProvinceChooseViewController.h"
#import "GYCityChooseViewController.h"
//选择区
#import "GYAreaChooseViewController.h"

@interface GYAddAddressSroViewController : GYViewController <UITextViewDelegate, UITextFieldDelegate, selectProvince, selectCity, selectArea>
@property (nonatomic, assign) BOOL boolstr; //用来控制push源，两个页面公用一个controller,用来区分
@property (nonatomic, assign) BOOL isFood; //区分餐饮  和零售
@property (nonatomic, copy) NSString *addrId;

@property (nonatomic, strong) GYAddressModel *model;


@end
