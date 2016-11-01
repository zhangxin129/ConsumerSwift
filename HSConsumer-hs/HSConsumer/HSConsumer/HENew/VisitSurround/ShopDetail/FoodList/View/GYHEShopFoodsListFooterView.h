//
//  GYHEShopFoodsListFooterView.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYFoodFooterType) {
    GYUnSelectedFoodFooterType = 1,
    GYSelectedFoodFooterType,
    
};

@class GYHEShopFoodsListFooterView;

@protocol GYHEShopFoodsListFooterViewDelegate <NSObject>

- (void)showCart:(GYHEShopFoodsListFooterView *)footerView;
- (void)payNow:(GYHEShopFoodsListFooterView *)footerView;

@end

@interface GYHEShopFoodsListFooterView : UIView

@property (nonatomic , assign)GYFoodFooterType type;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
//起送价格
@property (nonatomic , assign)CGFloat freeShippingPrice;
@property (nonatomic, weak)id<GYHEShopFoodsListFooterViewDelegate> delegate;

- (void)updateType:(GYFoodFooterType)type;

@end
