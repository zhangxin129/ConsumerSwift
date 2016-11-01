//
//  GYProvinceChooseViewController.h
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  选省份

#import <UIKit/UIKit.h>

@class GYProvinceChooseModel;
@protocol selectProvince <NSObject>

- (void)selectOneProvince:(GYProvinceChooseModel*)model;

@end

@interface GYProvinceChooseViewController : GYViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* marrDatasource;
@property (nonatomic, weak) id<selectProvince> delegate;

+(GYProvinceChooseViewController *)shareInstance;

//通过省份名称查找省份代码
-(NSString *)queryProvinceCodePassProvinceName:(NSString *)provinceName;

@end
