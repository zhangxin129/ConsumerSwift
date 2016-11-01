//
//  GYBankTableViewCell.h
//  HSConsumer
//
//  Created by apple on 15/12/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYQuickPayModel;

@interface GYBankTableViewCell : UITableViewCell

@property (nonatomic, strong) GYQuickPayModel* model;

// 如果判断是否需要系统的设置
@property (nonatomic, assign) BOOL notSystemSelect;
- (void) setSelectedState:(BOOL)state;

@end
