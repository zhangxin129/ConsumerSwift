//
//  ViewForRefundDetailsLeft.h
//  HSConsumer
//
//  Created by liangzm on 15-2-27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewForRefundDetailsLeft : UIView

@property (strong, nonatomic) IBOutlet UIView* viewLine0;
@property (weak, nonatomic) IBOutlet UILabel* createRequestLab;
@property (weak, nonatomic) IBOutlet UILabel* buyerAskLab;
@property (weak, nonatomic) IBOutlet UILabel* backMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel* backPVLab;
@property (weak, nonatomic) IBOutlet UILabel* instructionReasonLab;

- (void)setValues:(NSArray *)arrValues;

@end

