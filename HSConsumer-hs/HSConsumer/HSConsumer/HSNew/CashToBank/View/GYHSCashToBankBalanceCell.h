//
//  GYHSCashToBankBalanceCell.h
//  HSConsumer
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSCashToBankBalanceCellIdentifier @"GYHSCashToBankBalanceCell"

#import <UIKit/UIKit.h>

@interface GYHSCashToBankBalanceCell : UITableViewCell

@property (nonatomic,strong) UITextField *detailTextField;//子标题
@property (nonatomic,strong) UIImageView *selectBankImageView;


-(void)refreshTitle:(NSString *)title placehold:(NSString *)placehold detail:(NSString *)detail;

@end
