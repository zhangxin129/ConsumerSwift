//
//  GYHEMapNearCell.h
//  HSConsumer
//
//  Created by zhengcx on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYNearAddressModel.h"

@interface GYHEMapNearCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nearAddressLabel;
@property (nonatomic, strong)GYNearAddressModel *model;

@end
