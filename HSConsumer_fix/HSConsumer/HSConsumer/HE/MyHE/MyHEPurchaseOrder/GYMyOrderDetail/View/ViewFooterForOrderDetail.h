//
//  ViewFooterForOrderDetail.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewFooterForOrderDetail : UIView

@property (strong, nonatomic) IBOutlet UILabel* lbLabelRealisticAmount; //实付金额
@property (strong, nonatomic) IBOutlet UILabel* lbLabelPoint; //消费积分

@property (strong, nonatomic) IBOutlet UILabel* lbRealisticAmount; //实付金额
@property (strong, nonatomic) IBOutlet UILabel* lbPoint; //消费积分

+ (CGFloat)getHeight;

@end
