//
//  GYMealTimeCell.h
//  HSConsumer
//
//  Created by appleliss on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYMealTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* title;
@property (weak, nonatomic) IBOutlet UILabel* labValue;

+ (instancetype)cellWithTableView:(UITableView*)tableView andindes:(NSIndexPath*)indexPath;
@end
