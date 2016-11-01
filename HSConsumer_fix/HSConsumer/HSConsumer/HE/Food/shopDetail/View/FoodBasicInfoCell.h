//
//  FoodBasicInfoCell.h
//  HSConsumer
//
//  Created by apple on 15/12/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDShopDetailModel.h"
#import "FDSelectFoodViewController.h"
#import "FDShopFoodModel.h"
@interface FoodBasicInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* phoneLabel; //电话

@property (weak, nonatomic) IBOutlet UILabel* locationLabel; //定位地址

@property (weak, nonatomic) IBOutlet UILabel* timeSinceLabel; //营业时间

@property (weak, nonatomic) IBOutlet UILabel* timeReceiveLabel; //接单时间
@property (weak, nonatomic) IBOutlet UILabel* shopInfomationLabel; //商铺信息

@property (weak, nonatomic) IBOutlet UIView* phoneBgView;

@property (weak, nonatomic) IBOutlet UIView* adressBgView;
@property (strong, nonatomic) FDShopDetailModel* model;
@property (weak, nonatomic) IBOutlet UIButton* telBtn;
@property (weak, nonatomic) IBOutlet UIButton* gpsBtn;
@property (nonatomic, strong) FDSelectFoodViewController* delegate;
@property (nonatomic, copy) NSString* maplocation; ///定位是否成功
@property(nonatomic, strong) FDShopFoodModel *shopModel;
@end
