//
//  ViewGoodsAmount.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewGoodsAmount : UIView

@property (strong, nonatomic) IBOutlet UIView* vBkg0;
@property (strong, nonatomic) IBOutlet UILabel* lbLabelAmount;
@property (strong, nonatomic) IBOutlet UILabel* lbLabelCourierFees;
@property (strong, nonatomic) IBOutlet UILabel* lbLabelPoint;

@property (strong, nonatomic) IBOutlet UILabel* lbAmount;
@property (strong, nonatomic) IBOutlet UILabel* lbCourierFees;
@property (strong, nonatomic) IBOutlet UILabel* lbPoint;

+ (CGFloat)getHeight;

@end
