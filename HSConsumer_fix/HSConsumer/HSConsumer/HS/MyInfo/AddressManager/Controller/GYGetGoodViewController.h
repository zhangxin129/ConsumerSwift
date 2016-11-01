//
//  GYGetGoodViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  选择收货地址

#import <UIKit/UIKit.h>
#import "GYsenderButton.h"
#import "GYGetAddressDelegate.h"

@interface GYGetGoodViewController : GYViewController <UITableViewDataSource, UITableViewDelegate, GYsenderButton, GYGetAddressDelegate>

@property (nonatomic, strong) NSMutableArray* marrDataSoure; //数据源数组
@property (nonatomic, weak) id<GYGetAddressDelegate> deletage;
@property (nonatomic, assign) BOOL isFood;


@end
