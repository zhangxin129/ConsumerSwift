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
typedef NS_ENUM(NSUInteger, GYProvinceViewControllerClickType) {
    GYProvinceViewControllerClickBack, //返回
    GYProvinceViewControllerClickPush //推
    
};
@class GYProvinceViewController, GYProvinceModel;
@protocol GYProvinceViewControllerDelegate <NSObject>
@optional
- (void)provinceViewController:(GYProvinceViewController*)vc didSelectedWithModel:(GYProvinceModel*)model;

@end
@interface GYProvinceViewController : UIViewController

@property (nonatomic, strong) GYAddressCountryModel* model;
@property (nonatomic, assign) GYProvinceViewControllerClickType type;
@property (nonatomic, weak) id<GYProvinceViewControllerDelegate> delegate;
@end
