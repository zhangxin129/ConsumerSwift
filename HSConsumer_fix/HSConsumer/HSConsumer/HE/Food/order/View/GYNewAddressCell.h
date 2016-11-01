//
//  GYNewAddressCell.h
//  HSConsumer
//
//  Created by appleliss on 15/10/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPayoffModel.h"
@interface GYNewAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* userIphone;
@property (weak, nonatomic) IBOutlet UILabel* userName;
@property (nonatomic, strong) AddrModel* addmodel;
@property (weak, nonatomic) IBOutlet UIImageView* imagess;
@property (weak, nonatomic) IBOutlet UIImageView* rightBtn;

+ (instancetype)cellWithTableView:(UITableView*)tableView;
@end
