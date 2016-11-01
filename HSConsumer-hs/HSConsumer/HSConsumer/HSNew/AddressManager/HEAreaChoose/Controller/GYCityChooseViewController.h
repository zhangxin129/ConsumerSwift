//
//  GYCityChooseViewController.h
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  选城市

#import <UIKit/UIKit.h>

@class GYCityChooseModel;
@protocol selectCity <NSObject>

- (void)selectOneCity:(GYCityChooseModel*)model;

@end

@interface GYCityChooseViewController : GYViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray* marrDatasource;
@property (nonatomic, copy) NSString* parentName;
@property (nonatomic, weak) id <selectCity> delegate;
@property (nonatomic,assign) BOOL isUnderProvinceSelected;

+(GYCityChooseViewController *)shareInstance;

//通过城市名称查找城市代码
-(NSString *)queryCityCodePassCityName:(NSString *)cityName;

@end
