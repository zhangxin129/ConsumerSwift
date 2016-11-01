//
//  GYConfirmationViewController.h
//  HSConsumer
//
//  Created by appleliss on 15/10/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYOrderModel.h"
#import "GYAddressModel.h"
#import "GYPayoffModel.h"
#import "FDOrderConfirmModel.h"
@interface GYConfirmationViewController : GYViewController
@property (weak, nonatomic) IBOutlet UILabel* baseViewLabel;
@property (weak, nonatomic) IBOutlet UIImageView* baseViewJBImage;
@property (weak, nonatomic) IBOutlet UILabel* baseViewMoney;
@property (weak, nonatomic) IBOutlet UIButton* requestButton;
@property (weak, nonatomic) IBOutlet UIButton* buttonAddress;
@property (weak, nonatomic) IBOutlet UITableView* myTableView;
@property (nonatomic, strong) GYOrderModel* orderModel;
@property (nonatomic, strong) GYAddressModel* addressModel;
@property (nonatomic, strong) AddrModel* addmodel;
@property (nonatomic, strong) FDOrderConfirmModel* orderConfirModel;
@property (nonatomic, strong) UIView* pickerBgView;
@end
