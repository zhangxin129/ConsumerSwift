//
//  GYAreaChooseViewController.h
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  选区 县

#import <UIKit/UIKit.h>

@class GYAreaChooseModel;
@protocol selectArea <NSObject>

- (void)selectOneArea:(GYAreaChooseModel*)model;

@end
@interface GYAreaChooseViewController : GYViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id<selectArea> delegate;
@property (nonatomic, strong) NSMutableArray* marrDatasource;
@property (nonatomic, copy) NSString *parentName;
@end
