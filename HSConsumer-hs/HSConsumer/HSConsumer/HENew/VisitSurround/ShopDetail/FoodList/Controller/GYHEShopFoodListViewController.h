//
//  GYHEShopFoodListViewController.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHEShopFoodsListFooterView.h"

@interface GYHEShopFoodListViewController : GYViewController

//主界面控制隐藏
@property (nonatomic ,strong)GYHEShopFoodsListFooterView *footerView;
@property (nonatomic, strong)NSDictionary *customCateInfo;

@end
