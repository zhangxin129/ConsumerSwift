//
//  GYShopLocationTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYShopLocationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* lbShopAddress;
@property (weak, nonatomic) IBOutlet UILabel* lbDistance;
@property (weak, nonatomic) IBOutlet UILabel* lbGoodName;

@property (weak, nonatomic) IBOutlet UIButton* btnCheckMap;
@property (weak, nonatomic) IBOutlet UIImageView* imgvSeproter;

@property (weak, nonatomic) IBOutlet UIImageView* imgvMapIcon;
@property (weak, nonatomic) IBOutlet UIButton* btnShopTel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* goodHeight;

@end
