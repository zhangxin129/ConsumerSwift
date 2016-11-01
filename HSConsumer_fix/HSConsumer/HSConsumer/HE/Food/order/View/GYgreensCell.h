//
//  GYgreensCell.h
//  HSConsumer
//
//  Created by appleliss on 15/9/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYgreensCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* lbGreensName; ///菜名
@property (weak, nonatomic) IBOutlet UILabel* lbGreensPirce; /////价格
@property (weak, nonatomic) IBOutlet UILabel* lbGreensPVPrice; ////PV价格
@property (weak, nonatomic) IBOutlet UIImageView* HSBImage;

@property (weak, nonatomic) IBOutlet UILabel* greensNum; ////数量
@property (weak, nonatomic) IBOutlet UILabel* X;
@property (weak, nonatomic) IBOutlet UIImageView* PvpointImage;

+ (instancetype)cellWithTableView:(UITableView*)tableView andindes:(NSIndexPath*)indexPath andtitleName:(NSString*)titleName andRMB:(NSString*)stringRMB andPV:(NSString*)stringPV;
@end
