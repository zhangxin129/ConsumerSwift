//
//  GYHDNextPushViewController.h
//  HSConsumer
//
//  Created by shiang on 15/12/30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDCustomerModel.h"
@interface GYHDBasicViewController : UIViewController
/**
 * 消息唯一标识符
 */
@property(nonatomic, copy)NSString *messageCard;
@property(nonatomic,strong)GYHDCustomerModel*model;
@property(nonatomic,copy)NSString* leftHeadIconStr;
@property(nonatomic,copy)NSString*  rightHeadIconStr;
@property(nonatomic,assign)BOOL isCustomer;//判断是否消费者
@end
