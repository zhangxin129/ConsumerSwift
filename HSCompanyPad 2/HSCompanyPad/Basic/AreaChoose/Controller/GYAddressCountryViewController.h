//
//  GYAddressCountryViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
/**国家地址选择*/
#import <UIKit/UIKit.h>
#import "GYAddressCountryModel.h"

typedef NSComparisonResult (^NSComparator)(id obj1, id obj2);

@protocol GYAddressCountryViewControllerDelegate <NSObject>

- (void)sendAddress:(GYCityAddressModel*)model;

@end

typedef void (^getAddress)(GYCityAddressModel* model);
@interface GYAddressCountryViewController : UITableViewController
/**已选地区*/
@property (nonatomic, copy) NSString* strSelectedArea;
/**是否有已经有选择的地区*/
@property (nonatomic, assign, getter=hasSelectedArea) BOOL selectedArea;

@property (nonatomic, copy) getAddress addressBlock;
@property (nonatomic,weak) id<GYAddressCountryViewControllerDelegate>delegate;


@end