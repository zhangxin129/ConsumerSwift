//
//  GYHSServerOrderViewController.h
//  HSConsumer
//
//  Created by kuser on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYViewController.h"
#import "GYHSServerOrderEnum.h"
#import "GYHSServerOrderActionEnum.h"

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GYHSShoppingListType) {
    GYHSShopRetailingTypeList = 0, //零售列表
    GYHSShopServeringTypeList = 1 //服务列表
};

@interface GYHSServerOrderViewController : GYViewController

@property (nonatomic, assign) GYHSShoppingListType shoppingListType;

@property (nonatomic, assign) EMServerOrderState* orderState;

@end
