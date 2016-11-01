//
//  GYOrderInDetailViewController.h
//  GYRestaurant
//
//  Created by ios007 on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  订单详情页面

#import "ViewController.h"


@interface GYOrderInDetailViewController : ViewController

@property (nonatomic, strong) NSDictionary *infoDic;
/**订单状态, 必须给*/
@property (nonatomic, copy)NSString *status;
/**店内或自提*/
@property (nonatomic, copy)NSString *strType;
@end
