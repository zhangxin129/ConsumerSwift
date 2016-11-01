//
//  GYnormalCell.h
//  HSConsumer
//
//  Created by appleliss on 15/10/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYcellModel.h"
@interface GYnormalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* image;
@property (weak, nonatomic) IBOutlet UILabel* title;
@property (weak, nonatomic) IBOutlet UILabel* value;
@property (strong, nonatomic) GYcellModel* model;
+ (instancetype)cellWithTableView:(UITableView*)tableView andindes:(NSIndexPath*)indexPath andtitleName:(NSString*)titleName;
@end
