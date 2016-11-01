//
//  ViewOrderStateInfo.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewOrderStateInfo : UIView

@property (strong, nonatomic) IBOutlet UIView* vLine;
@property (strong, nonatomic) IBOutlet UILabel* lbState;
@property (strong, nonatomic) IBOutlet UILabel* lbOrderNo;
@property (strong, nonatomic) IBOutlet UILabel* lbOrderDatetime;
//zhangqiyun 自提码
@property (weak, nonatomic) IBOutlet UILabel* lbOrderTakeCode;

+ (CGFloat)getHeight;
@end
