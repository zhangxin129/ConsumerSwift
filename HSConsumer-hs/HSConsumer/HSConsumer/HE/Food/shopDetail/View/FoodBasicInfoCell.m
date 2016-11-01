
//
//  FoodBasicInfoCell.m
//  HSConsumer
//
//  Created by apple on 15/12/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FoodBasicInfoCell.h"

#import "GYAppDelegate.h"
#import "GYBMKViewController.h"
#import "GYAroundLocationChooseController.h"
@implementation FoodBasicInfoCell

- (void)awakeFromNib
{

    //    [self.phoneBgView addTopBorder];
    //
    //    [self.adressBgView addTopBorderAndBottomBorder];
    //
    //    [self.timeSinceLabel addBottomBorder];

    self.shopInfomationLabel.text = kLocalized(@"GYHE_Food_ShopInfomation");
}

- (void)setModel:(FDShopDetailModel*)model
{

    _model = model;
    _phoneLabel.text = model.reservePhoneNo;

    _locationLabel.text = model.addall;

    _timeSinceLabel.text = [NSString stringWithFormat:@"  %@: %@", kLocalized(@"GYHE_Food_BusinessHours"), model.openingHours];
    _timeReceiveLabel.text = [NSString stringWithFormat:@"  %@: %@", kLocalized(@"GYHE_Food_PickTime"), model.orderHours];
}

- (void)setShopModel:(FDShopFoodModel*)shopModel
{

    _shopModel = shopModel;
}

- (IBAction)phoneNumCall:(UIButton*)sender
{

    [GYUtils callPhoneWithPhoneNumber:_model.reservePhoneNo showInView:kAppDelegate.window];
}

- (IBAction)gpsLocation:(UIButton*)sender
{

    CLLocationCoordinate2D coordinateShop;
    //
    //    if (globalData.selectedCityCoordinate) {
    //
    //        ////目前是默认手动选中地址。如果没有精确定地址就给一个标示  定位失败
    //
    //        NSArray*arr=[globalData.selectedCityCoordinate componentsSeparatedByString:@","];
    //
    //        coordinateShop.latitude=[arr[0] floatValue];
    //        coordinateShop.longitude=[arr[1] floatValue];
    //
    //
    //    }else{

    NSArray* arr = [_model.landmark componentsSeparatedByString:@","];
    coordinateShop.latitude = [arr[0] floatValue];
    coordinateShop.longitude = [arr[1] floatValue];

    //    }

    FDSelectFoodViewController* vc = (FDSelectFoodViewController*)_delegate;
    GYBMKViewController* mapVC = [[GYBMKViewController alloc] init];
    mapVC.strShopId = _shopModel.shopId;
    mapVC.coordinateLocation = coordinateShop;
    mapVC.title = kLocalized(@"GYHE_Food_MapShows");
    [vc.navigationController pushViewController:mapVC animated:YES];
}

- (void)layoutSubviews
{

    [super layoutSubviews];

    //    [self.phoneBgView addTopBorder];
    //
    //    [self.adressBgView addTopBorderAndBottomBorder];
    //
    //    [self.timeSinceLabel addBottomBorder];
}

@end
