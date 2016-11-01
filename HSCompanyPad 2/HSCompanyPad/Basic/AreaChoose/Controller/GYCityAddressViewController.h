//
//  GYProvinceViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAddressCountryModel.h"
typedef NS_ENUM(NSUInteger, GYCityAddressViewControllerClickType) {
    GYCityAddressViewControllerClickBack, //返回
    GYCityAddressViewControllerClickPush //推
    
};
@class GYCityAddressViewController, GYCityAddressModel;
@protocol GYCityAddressViewControllerDelegate <NSObject>
@optional
- (void)cityAddressViewController:(GYCityAddressViewController*)vc didSelectedWithModel:(GYCityAddressModel*)model;

@end
@interface GYCityAddressViewController : UIViewController
@property (nonatomic, strong) GYProvinceModel* model;
@property (nonatomic, assign) GYCityAddressViewControllerClickType type;
@property (nonatomic, weak) id<GYCityAddressViewControllerDelegate> delegate;
@end
