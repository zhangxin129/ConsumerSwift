//
//  GYAllShopTableViewCell.h
//  HSConsumer
//
//  Created by apple on 15/6/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYAllShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* lbAddr;
@property (weak, nonatomic) IBOutlet UILabel* lbDistance;
@property (weak, nonatomic) IBOutlet UIImageView* imgDistance;
@property (weak, nonatomic) IBOutlet UIButton* btnShopTel;

@end
