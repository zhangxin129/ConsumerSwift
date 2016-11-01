//
//  ViewHeaderForMyOrder.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewHeaderForMyOrder : UIView
@property (strong, nonatomic) IBOutlet UILabel* lbState;
@property (strong, nonatomic) IBOutlet UILabel* lbOrderNo;
@property (strong, nonatomic) IBOutlet UIButton* btnTrash;
@property (strong, nonatomic) IBOutlet UIView* viewLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* lbStateConstraint;
@property (weak, nonatomic) IBOutlet UILabel* refundTypeLabel; //售后状态

@property (strong, nonatomic) IBOutlet UIButton* btnShopName; //商铺名称
@property (strong, nonatomic) IBOutlet UIButton* btnShopName2; //箭头


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbstateDistanceTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateDistanceTop;


@property (weak, nonatomic) IBOutlet UIButton* buttonArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderNumberConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderNumberDistaceTopConstraint;


+ (CGFloat)getHeight;

@end
