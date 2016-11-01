//
//  GYShopFoodDetailView.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYShopFoodDetailView : UIView

@property (nonatomic,strong) UIView *detailView;
@property (nonatomic,strong) UIViewController *vc;

- (void)createViewWithVC:(UIViewController *)vc ;
- (void)dismissView;

@end
