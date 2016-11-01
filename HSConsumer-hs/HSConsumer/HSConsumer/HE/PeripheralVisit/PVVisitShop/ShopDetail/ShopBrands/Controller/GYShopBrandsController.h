//
//  GYShopBrandsController.h
//  HSConsumer
//
//  Created by apple on 15/11/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYShopBrandsController;

@protocol GYShopBrandsControllerDelegate <NSObject>
@optional
- (void)ShopBrandDidChooseBrand:(NSArray*)brand;

@end

@interface GYShopBrandsController : GYViewController

@property (nonatomic, copy) NSString* strShopID;
@property (nonatomic, weak) id<GYShopBrandsControllerDelegate> delegate;
@end
