//
//  FDMainFoodTableViewCell.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
typedef void (^PushCommitVC)(UIViewController* vc);
#import <UIKit/UIKit.h>
#import "FDShopModel.h"
#import "FDMainViewController.h"

@interface FDMainShopTableViewCell : UITableViewCell
@property (strong, nonatomic) FDShopModel* model;
@property (copy, nonatomic) PushCommitVC pushCommitVCBlock;
@end
