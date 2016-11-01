//
//  GYHDCustomerInfoViewController.h
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "ViewController.h"
#import "GYHDCustomerModel.h"
#import "GYHDCustomerDetailModel.h"
@interface GYHDCustomerInfoViewController : ViewController
@property(nonatomic,strong)GYHDCustomerModel*model;
@property(nonatomic,strong)GYHDCustomerDetailModel*customerDetailModel;
@property(nonatomic,assign)BOOL isClickSelf;//判断是否点击自己的头像
@property(nonatomic,assign)BOOL isFromCustomer;//判断是否从消费者页面进入 用来相册选择后回调
@end
