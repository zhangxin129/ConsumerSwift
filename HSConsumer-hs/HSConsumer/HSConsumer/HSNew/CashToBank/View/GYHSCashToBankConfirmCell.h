//
//  GYHSCashToBankConfirmCell.h
//  HSConsumer
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSCashToBankConfirmCellIdentifier @"GYHSCashToBankConfirmCell"

#import <UIKit/UIKit.h>

@interface GYHSCashToBankConfirmCell : UITableViewCell

-(void)refreshTitle:(NSString *)title detail:(NSString *)detail;

@end
