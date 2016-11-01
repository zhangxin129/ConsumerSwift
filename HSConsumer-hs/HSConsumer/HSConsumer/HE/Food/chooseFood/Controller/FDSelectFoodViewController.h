//
//  FDSelectFoodViewController.h
//  HSConsumer
//
//  Created by apple on 15/12/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDMainModel.h"
#import "FDFoodModel.h"
#import "FDChoosedFoodModel.h"
@interface FDSelectFoodViewController : GYViewController
@property (strong, nonatomic) FDShopModel* shopModel;
@property (assign, nonatomic) BOOL isTakeaway;
@property (copy, nonatomic) NSString* landMark;
@property (copy, nonatomic) NSString* shopId;
@property (copy, nonatomic) NSString* vShopId;
@property (copy, nonatomic) NSString* shopName;
@property (assign, nonatomic) BOOL isSendRange;
@property (assign, nonatomic) BOOL isSearch;
@property (nonatomic, copy) NSString* foodId;
@property (nonatomic, copy) NSString* dist;
- (void)cellValueChangedChoosedModel:(FDChoosedFoodModel*)model Cell:(UITableViewCell*)cell View:(UIView*)view;
- (void)showFoodFormatChoosedVC:(FDChoosedFoodModel*)model;
@end
