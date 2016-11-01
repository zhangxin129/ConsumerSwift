//
//  GYRecstaurantTableViewCell.h
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

#define KGYRecstaurantTableViewCell @"GYRecstaurantTableViewCellCell"

@protocol GYRecstaurantTableViewCellDelegate <NSObject>
- (void)GYRecstaurantTableViewCellcalorder:(GYOrderModel*)model;
- (void)GYRecstaurantTableViewCellshowAlart;
- (void)GYRecstaurantTableViewCellconfirm:(GYOrderModel*)model; ///企业给消费者下单 消费者确认 去评价
- (void)GYRecstaurantTableViewCellDelegateIMChact:(GYOrderModel*)model;
@end
@interface GYRecstaurantTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView*)tableView;
@property (weak, nonatomic) IBOutlet UILabel* lbOrderState; ////订单状态
@property (weak, nonatomic) IBOutlet UILabel* lbHSNumber; ////互生号
@property (weak, nonatomic) IBOutlet UILabel* lbTime;
@property (weak, nonatomic) IBOutlet UILabel* lbPersonNumber; ///用餐人数
@property (weak, nonatomic) IBOutlet UILabel* lbJBNumber; ///互生币

@property (weak, nonatomic) IBOutlet UIButton* btnCancl; ///取消订单
@property (weak, nonatomic) IBOutlet UILabel* lbTitleTime; //时间title

@property (weak, nonatomic) IBOutlet UIButton* btnPay; ////立即支付 和评价

@property (weak, nonatomic) IBOutlet UILabel* topBg;
@property (weak, nonatomic) IBOutlet UILabel* lbOrderNuber; /////订单号
@property (weak, nonatomic) IBOutlet UILabel* lbPersonNumberTitle; ////用餐人数
@property (weak, nonatomic) IBOutlet UILabel* lbOrderTitle;

@property (nonatomic, strong) GYOrderModel* model;
@property (nonatomic, weak) id<GYRecstaurantTableViewCellDelegate> gydelegate;
//add zhangx 国际化
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;//订单号:

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceTopConstraint;




@end
