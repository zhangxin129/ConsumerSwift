//
//  FDShopCommitCell.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDShopCommitModel.h"
#import "FDSelectFoodViewController.h"
@interface FDShopCommitCell : UITableViewCell
@property (strong, nonatomic) FDShopCommitModel* model;
@property (strong, nonatomic) FDSelectFoodViewController* dele;
@property (weak, nonatomic) IBOutlet UIView* bottonView;
@property (nonatomic, assign) BOOL isSeviceTableView; //判断是否时服务列表

@end
