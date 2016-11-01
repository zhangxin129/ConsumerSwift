//
//  GYHESCPaymentMethodTableViewCell.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHESCPaymentMethodModel.h"

@interface GYHESCPaymentMethodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* contentLabel;
@property (weak, nonatomic) IBOutlet UILabel* userfulBalanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView* iconImageView;
@property (weak, nonatomic) IBOutlet UILabel* moneyNumberLabel;

- (void)refreshDataWithModel:(GYHESCPaymentMethodModel*)model;
@end
