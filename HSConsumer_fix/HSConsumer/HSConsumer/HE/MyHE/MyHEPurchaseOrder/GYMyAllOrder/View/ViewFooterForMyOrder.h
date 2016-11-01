//
//  ViewFooterForMyOrder.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewFooterForMyOrder : UIView

// 实付款:
@property (strong, nonatomic) IBOutlet UILabel* lbLabelMoney;
@property (strong, nonatomic) IBOutlet UILabel* lbMoneyAmount;
@property (strong, nonatomic) IBOutlet UIImageView* ivPointFlag;
@property (strong, nonatomic) IBOutlet UILabel* lbPointAmount;

// 售后申请
@property (strong, nonatomic) IBOutlet UIButton* btn0;

// 再次购买
@property (strong, nonatomic) IBOutlet UIButton* btn1;
@property (weak, nonatomic) IBOutlet UIButton* deliverBtn; //发货按钮

// 退还积分
@property (weak, nonatomic) IBOutlet UILabel* backPVLabel;

@property (weak, nonatomic) IBOutlet UIButton* viewClickBtn;

@property (weak, nonatomic) IBOutlet UIButton* footClickBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* scoreLabelDistanceLeft;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn1DistanceTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn0DistanceTopConstraint;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint* pvLabelDistanceLeft;

+ (CGFloat)getHeight;
@end
