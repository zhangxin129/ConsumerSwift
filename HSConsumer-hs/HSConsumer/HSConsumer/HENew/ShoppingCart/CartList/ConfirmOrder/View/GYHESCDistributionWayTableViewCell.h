//
//  GYHESCDistributionWayTableViewCell.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHESCDistributionWayModel.h"

@interface GYHESCDistributionWayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* distributionWayLabel;
@property (weak, nonatomic) IBOutlet UIImageView* coinImageView;
@property (weak, nonatomic) IBOutlet UILabel* moneyLabel;

- (void)refreshDataWithModel:(GYHESCDistributionTypeModel*)model fee:(NSString*)feeString;

@end
