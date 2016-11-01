//
//  GYOderInPaidCell.h
//  GYRestaurant
//
//  Created by ios007 on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYOrderListModel;
@interface GYOderInPaidCell : UITableViewCell

//订单号
@property (weak, nonatomic) IBOutlet UILabel *ordIdLabel;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *useIdLabel;
//开始时间
@property (weak, nonatomic) IBOutlet UILabel *orderStartDatetimeLabel;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
//人民币图
@property (weak, nonatomic) IBOutlet UIImageView *coinImageV;
//金额
@property (weak, nonatomic) IBOutlet UILabel *orderPayCountLabel;
//结束时间
@property (weak, nonatomic) IBOutlet UILabel *ordFinishTimeLabel;


@end
