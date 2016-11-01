//
//  GYShopDetailHeaderView.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchGoodModel.h"
#import "GYSurrondGoodsDetailModel.h"
@interface GYGoodDetailHeaderView : UIView
@property (nonatomic, strong) UIImageView* imgvGoodPicture;
@property (nonatomic, strong) UILabel* lbGoodPrice;

@property (nonatomic, strong) UIButton* btnAttention;
//@property (nonatomic,strong)UIButton * btnEnterVShop;
@property (nonatomic, strong) UIImageView* imgvPointIcon;
@property (nonatomic, strong) UILabel* lbPoint;
//@property (nonatomic,strong)UIButton * btnEnterShop;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) id ower;
@property (nonatomic, strong) UIScrollView* mainScrollView;
@property (nonatomic, assign) CGRect superFrame;
@property (nonatomic, strong) UIView* vBottomBackground;

@property (nonatomic, strong) UILabel* lbMonthSale;

// add by songjk
@property (nonatomic, weak) UILabel* lbExpressTitle;
@property (nonatomic, weak) UIImageView* mvExpressCoin;
@property (nonatomic, weak) UILabel* lbExpressFee;
@property (nonatomic, weak) UILabel* lbExpressInfo;
- (id)initWithShopModel:(SearchGoodModel*)model WithFrame:(CGRect)rect WithOwer:(id)ower;

- (void)setInfoForHeaderView:(GYSurrondGoodsDetailModel*)model;
@end
