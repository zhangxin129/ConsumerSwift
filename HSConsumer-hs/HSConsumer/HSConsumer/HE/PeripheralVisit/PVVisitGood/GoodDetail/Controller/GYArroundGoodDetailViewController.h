//
//  GYArroundGoodDetailViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchGoodModel.h"

@interface GYArroundGoodDetailViewController : GYViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton* btnContactShop;
@property (weak, nonatomic) IBOutlet UIButton* btnBrowse;
@property (weak, nonatomic) IBOutlet UIView* vBottomView;
@property (weak, nonatomic) IBOutlet UIButton* btnAddToShopCar;
@property (nonatomic, assign) BOOL fromHotGoods;

@property (weak, nonatomic) IBOutlet UIButton* btnContactShopPop;
@property (weak, nonatomic) IBOutlet UIButton* btnAddToShopCarPop;
@property (weak, nonatomic) IBOutlet UIButton* btnBrowsePop;
@property (weak, nonatomic) IBOutlet UIButton* btnEnterShop;
@property (weak, nonatomic) IBOutlet UIButton* btnEnterShopPro;

@property (weak, nonatomic) IBOutlet UIView* vBottomViewPop;

@property (nonatomic, strong) SearchGoodModel* model;

@end
