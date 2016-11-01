//
//  GYConfirmOrdersController.h
//  HSConsumer
//
//  Created by appleliss on 15/9/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYCommentViewController.h"
////model
#import "GYOrderModel.h"
#import "GYAddressModel.h"
#import "GYPayoffModel.h"
#import "FDOrderConfirmModel.h"
@interface GYConfirmOrdersController : GYViewController <UITableViewDataSource, UITableViewDelegate, GYCommentViewControllerDelegate> {
}
@property (nonatomic, strong) UITableView* orderstable;
@property (nonatomic, strong) UIView* baseview; ///底部的View
@property (nonatomic, strong) UIPickerView* picker;
@property (nonatomic, strong) UIDatePicker* datepicker;
@property (nonatomic, strong) UIView* pickerBgView;
@property (nonatomic, strong) UILabel* timelabel; ///配送时间
@property (nonatomic, strong) UITextField* numbPerson; ////用餐人数
@property (nonatomic, strong) UILabel* consumption; ////人均消费
@property (nonatomic, strong) GYOrderModel* orderModel;
@property (nonatomic, strong) GYAddressModel* addressModel;
@property (nonatomic, strong) AddrModel* addmodel;
@property (nonatomic, strong) FDOrderConfirmModel* orderConfirModel;
@property(nonatomic, strong) UISwitch *isSwitch;///开具发票

@end
