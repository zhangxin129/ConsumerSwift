//
//  GYShopInfoWithLocationCell.h
//  HSConsumer
//
//  Created by Apple03 on 15-5-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYShopInfoWithLocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* lbHsNumber;
@property (weak, nonatomic) IBOutlet UILabel* lbShopAddress;
@property (weak, nonatomic) IBOutlet UIButton* btnPhoneCall;

@property (weak, nonatomic) IBOutlet UILabel* lbDistance;

@property (weak, nonatomic) IBOutlet UIButton* btnCheckMap;
@property (weak, nonatomic) IBOutlet UIImageView* imgvSeproter;

@property (weak, nonatomic) IBOutlet UIImageView* imgvMapIcon;
@end
