//
//  GYHSSysResPurchaseVC.h
//
//  Created by apple on 16/8/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"

@class GYProductModel;

@interface GYHSSysResPurchaseVC: GYBaseViewController

@property (nonatomic, strong) NSMutableArray *transArray;
@property (nonatomic, strong) GYProductModel* productModel;
@property (nonatomic, copy) NSString *price;

@end
