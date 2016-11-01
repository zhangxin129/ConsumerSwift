//
//  GYHEShopFoodCartView.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEShopFoodCartView : UIView

@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (nonatomic, strong)NSMutableArray *arr;
@property (nonatomic, copy)void(^foodCartClearBlock)(); 

- (void)addToParentVC:(UIViewController *)parentVC;
- (void)removeFromWindow;


@end
