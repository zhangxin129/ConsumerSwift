//
//  GYRestaurantOrderViewController.h
//  HSConsumer
//
//  Created by appleliss on 15/9/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYOrderModel.h"
//////   V
#import "GYRecestaurantOutCell.h"
#import "GYRecstaurantTableViewCell.h"
@interface GYRestaurantOrderViewController : GYViewController <GYRecstaurantTableViewCellDelegate, GYRecestaurantOutCellDelegate>
@property (nonatomic, strong) UITableView* mytable;
@property (nonatomic, copy) NSString* strTyp;
@property (nonatomic, strong) UINavigationController* nav;
@property (nonatomic, assign) int startPageNo; //从第几开始 这里默认从第1页开始传
@end
