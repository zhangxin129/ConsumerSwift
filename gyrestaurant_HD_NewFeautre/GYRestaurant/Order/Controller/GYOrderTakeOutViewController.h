//
//  GYOrderTakeOutViewController.h
//  GYRestaurant
//
//  Created by ios007 on 15/10/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewController.h"

@interface GYOrderTakeOutViewController : ViewController
@property (nonatomic, strong) NSDictionary *idDic;

@property (nonatomic ,strong) NSMutableArray *dataArr;

/**搜索框的资源号、订单号、手机号*/
@property (nonatomic ,copy)NSString *strResNO;

@end
