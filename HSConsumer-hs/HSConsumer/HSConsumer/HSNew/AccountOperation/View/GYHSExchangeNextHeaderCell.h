//
//  GYHSExchangeNextHeaderCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSExchangeNextHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLb;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLb;
@property (weak, nonatomic) IBOutlet UILabel *submittedSuccessLb;
@property (weak, nonatomic) IBOutlet UILabel *exchangeHSBLb;
@property (weak, nonatomic) IBOutlet UIView *intervalView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
