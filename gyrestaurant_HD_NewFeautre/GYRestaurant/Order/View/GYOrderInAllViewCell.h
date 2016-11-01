//
//  GYOrderInAllViewCell.h
//  GYRestaurant
//
//  Created by apple on 15/12/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYOrderInAllViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderIdLable;
@property (weak, nonatomic) IBOutlet UILabel *resNoLable;
@property (weak, nonatomic) IBOutlet UILabel *orderStartLable;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLable;
@property (weak, nonatomic) IBOutlet UIImageView *coinView;
@property (weak, nonatomic) IBOutlet UILabel *orderAcountLable;
@property (weak, nonatomic) IBOutlet UILabel *orderPaymentLable;

@end
