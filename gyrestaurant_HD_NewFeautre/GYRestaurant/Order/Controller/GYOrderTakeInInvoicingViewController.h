//
//  GYOrderTakeInInvoicingViewController.h
//  GYRestaurant
//
//  Created by apple on 15/10/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  结账页面

#import "ViewController.h"


@interface GYOrderTakeInInvoicingViewController : ViewController
/**存储userId和orderId*/
@property (nonatomic, strong)NSDictionary *infoDic;
/**记录是否是push进来的，默认是NO*/
@property (nonatomic, assign)BOOL isPush;

@end
