//
//  GYShopDescribeController.h
//  HSConsumer
//
//  Created by apple on 15/11/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@class ShopModel;

@interface GYShopDescribeController : GYViewController

@property (nonatomic, strong) ShopModel* shopModel;
@property (nonatomic, assign) BMKMapPoint currentMp1;

@end
