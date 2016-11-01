//
//  GYAroundEvaluateDetailViewController.h
//  HSConsumer
//
//  Created by apple on 15-2-12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYAroundEvaluateDetailViewController : GYViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSString* strGoodId;
@property (nonatomic, strong) UINavigationController* nav;
@property (nonatomic, copy) NSString* EvaluteStatus;
@property (nonatomic, strong) NSMutableArray* marrDatasource;
@end
