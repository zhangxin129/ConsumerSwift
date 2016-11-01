//
//  GYOrderTakeOutDetailViewController.h
//  GYRestaurant
//
//  Created by ios007 on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewController.h"

@interface GYOrderTakeOutDetailViewController : ViewController
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, copy) NSString *userIdStr;
@property (nonatomic, copy) NSString *orderIdStr;
@property (nonatomic, strong) NSString *status;

@end
