//
//  GYShopheaderViewController.h
//  HSConsumer
//
//  Created by appleliss on 15/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"

@interface GYShopheaderView : UIView
@property (nonatomic, strong) UIImageView* imgvShopPicture;
@property (nonatomic, strong) UILabel* lbShopName;
@property (nonatomic, strong) UIButton* btnCollect;
@property (nonatomic, strong) UIButton* btnAttention;
@property (nonatomic, strong) UIButton* btnShare;
@property (nonatomic, strong) UIScrollView* srcView;
@property (nonatomic, strong) UIPageControl* PageControl;
@property (nonatomic, assign) CGRect superframe;
@property (nonatomic, strong) id Ower;
@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, strong) UILabel* gradeLabel; ////评分
@property (nonatomic, strong) UIImageView* gradeView; /////五个星星
@property (nonatomic, strong) UIView* grdeview; //////放星星评价
- (id)initWithShopModel:(CGRect)rect WithOwer:(id)ower;

- (void)setShopInfo:(ShopModel *)model;
@end
