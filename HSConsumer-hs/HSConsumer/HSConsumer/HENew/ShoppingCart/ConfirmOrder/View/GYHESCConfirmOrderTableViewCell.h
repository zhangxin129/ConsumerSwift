//
//  GYHESCConfirmOrderTableViewCell.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/28.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHESCCartListModel.h"

@interface GYHESCConfirmOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel* describleLabel;
@property (weak, nonatomic) IBOutlet UILabel* skuLabel;
@property (weak, nonatomic) IBOutlet UILabel* moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel* pvLabel;
@property (weak, nonatomic) IBOutlet UILabel* numberLabel;

- (void)refreshDataWithModel:(GYHESCCartListModel*)model;
@end
