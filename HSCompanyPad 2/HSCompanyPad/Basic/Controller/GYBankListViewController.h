//
//  GYBankListViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GYLoginModel.h"
@protocol sendSelectBankDelegate <NSObject>
@optional

- (void)getBank:(BankModel*)model;

@end

@interface GYBankListViewController : UITableViewController
@property (nonatomic, strong) NSMutableDictionary* nameDictionary;
@property (nonatomic, weak) id<sendSelectBankDelegate> delegate;
@end
