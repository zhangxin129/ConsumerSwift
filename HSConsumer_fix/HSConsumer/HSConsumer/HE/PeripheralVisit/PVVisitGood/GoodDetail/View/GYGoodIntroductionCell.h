//
//  GYGoodIntroductionCell.h
//  HSConsumer
//
//  Created by Apple03 on 15-5-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYGoodIntroductionModel;
static NSString* strDetailIdent = @"goodDetail";

@interface GYGoodIntroductionCell : UITableViewCell
@property (nonatomic, strong) GYGoodIntroductionModel* model;
+ (instancetype)cellWithTableView:(UITableView*)tableView;
@end
