//
//  GYShopAboutViewController.h
//  HSConsumer
//
//  Created by appleliss on 15/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"
#import "GYCitySelectViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface GYShopAboutViewController : GYViewController <UITableViewDataSource, UITableViewDelegate, BMKLocationServiceDelegate, UIScrollViewDelegate> {
    BMKLocationService* _locService;
@public
    BMKMapPoint mp1;
}

@property (nonatomic, copy) NSString* ShopID; //传值：商铺ID
@property (nonatomic, copy) NSString* strVshopId;
@property (nonatomic, copy) NSString* strShopDistance;
@property (nonatomic, strong) ShopModel* model;
@property (nonatomic, assign) BMKMapPoint currentMp1;
@end