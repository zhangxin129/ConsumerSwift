//
//  GYHDFriendCell.h
//  HSConsumer
//
//  Created by shiang on 16/1/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  朋友Cell

//#import <UIKit/UIKit.h>
#import "GYHDBaseCell.h"

@class GYHDFriendModel;
@interface GYHDFriendCell : GYHDBaseCell
@property (nonatomic, strong) GYHDFriendModel* friendModel;
//+ (instancetype)cellWithTableView:(UITableView*)tableView;
@end
