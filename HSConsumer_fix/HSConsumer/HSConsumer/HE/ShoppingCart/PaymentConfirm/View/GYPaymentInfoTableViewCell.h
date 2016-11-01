//
//  GYPaymentInfoTableViewCell.h
//  HSConsumer
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYPaymentInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTagLabel;

@end
