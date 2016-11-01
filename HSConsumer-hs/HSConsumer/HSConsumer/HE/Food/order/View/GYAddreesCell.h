//
//  GYAddreesCell.h
//  HSConsumer
//
//  Created by appleliss on 15/9/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYOrderModel.h"
@interface GYAddreesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* addressUserInCell; //// 地址
@property (weak, nonatomic) IBOutlet UILabel* lbaddressUserInName; ///用户名
@property (weak, nonatomic) IBOutlet UILabel* lbaddressUserphone; /// 用户电话
@property (weak, nonatomic) IBOutlet UIButton* arrowImage;
@property (weak, nonatomic) IBOutlet UILabel* lbNametitle;
@property (copy, nonatomic) GYOrderModel* moder;
@property (weak, nonatomic) IBOutlet UIImageView *colorbar;

@end
