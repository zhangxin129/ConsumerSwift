//
//  GYRecestaurantOutCell.h
//  HSConsumer
//
//  Created by appleliss on 15/9/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYOrderModel.h"
#import "GYRecstaurantTableViewCell.h"

#define KGYRecestaurantOutCell @"GYRecestaurantOutCell"

@protocol GYRecestaurantOutCellDelegate <NSObject>
- (void)GYRecestaurantOutCellConfirm:(GYOrderModel*)model;

@end
@interface GYRecestaurantOutCell : UITableViewCell
@property (strong, nonatomic) NSDictionary* dicDataSource;
@property (nonatomic, strong) UINavigationController* nav;
@property (weak, nonatomic) IBOutlet UILabel* shopName;

@property (weak, nonatomic) IBOutlet UILabel* lbOrderState; ////订单状态
@property (weak, nonatomic) IBOutlet UILabel* lbHSNumber; ////互生号
@property (weak, nonatomic) IBOutlet UILabel* lbTime;
@property (weak, nonatomic) IBOutlet UILabel* lbJBNumber; ///互生币

@property (weak, nonatomic) IBOutlet UIButton* btnCancl; ///取消订单
@property (weak, nonatomic) IBOutlet UILabel* lbTitleTime; //时间title

@property (weak, nonatomic) IBOutlet UIButton* btnPay; ////立即支付 和评价
@property (weak, nonatomic) IBOutlet UILabel* lbIntegral; ////积分的
@property (weak, nonatomic) IBOutlet UIImageView* imgPv; ////图片
@property (weak, nonatomic) IBOutlet UILabel* lbPVNumber; ////积分值
@property (weak, nonatomic) IBOutlet UILabel* topBg;
@property (weak, nonatomic) IBOutlet UILabel* lbOrderNuber; /////订单号
@property (nonatomic, weak) id<GYRecstaurantTableViewCellDelegate> gyRecstaurantTableViewCellDelegate;
@property (nonatomic, weak) id<GYRecestaurantOutCellDelegate> gyRecestaurantOutCellDelegate;
@property (nonatomic, strong) GYOrderModel* model;
//国际化 add zhangx

@property (weak, nonatomic) IBOutlet UILabel* orderNumLabel; //订单号：
@property (weak, nonatomic) IBOutlet UILabel* orderPaymentLabel; //订单金额:

+ (instancetype)cellWithTableView:(UITableView *)tableView andDelegate:(id)delegate;
@end
