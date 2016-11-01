//
//  GYOtherPayStyleViewSpecialCell.h
//  HSConsumer
//
//  Created by Apple03 on 15/12/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYOtherPayStyleViewSpecialCell : UITableViewCell
//账户余额
@property (weak, nonatomic) IBOutlet UILabel* cashAccountBalanceLabel;
//选中与未选中图片
@property (weak, nonatomic) IBOutlet UIImageView* selectImageView;
@property (weak, nonatomic) IBOutlet UILabel* currencyAccountPayLabel; //货币账户支付
@property (weak, nonatomic) IBOutlet UILabel *balancesLabel;//余额:

@end
