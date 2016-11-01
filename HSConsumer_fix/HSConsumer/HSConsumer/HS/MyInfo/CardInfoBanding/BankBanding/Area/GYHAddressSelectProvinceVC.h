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

@class GYHSProvinceModel;
@protocol ProvinceSelectDelegate <NSObject>

@optional
- (void)didSelectProvinceModel:(GYHSProvinceModel*)model;

@end

@interface GYHAddressSelectProvinceVC : GYViewController

@property (nonatomic, copy) NSMutableString* mstrCountry;
@property (nonatomic, copy) NSString* areaId;
@property (nonatomic, strong) NSIndexPath* selectIndexPath;

@property (nonatomic, weak) id<ProvinceSelectDelegate> delegate;

@property (nonatomic, assign) BOOL isFromAddressVC; //是否父级控制器是收货地址管理

@end
