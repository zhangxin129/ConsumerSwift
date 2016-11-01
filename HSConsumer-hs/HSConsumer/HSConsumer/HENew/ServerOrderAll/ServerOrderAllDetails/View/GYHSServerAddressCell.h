//
//  GYHSServerAddressCell.h
//  HSConsumer
//
//  Created by zhengcx on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSServerDetailAllModel;

@interface GYHSServerAddressCell : UITableViewCell

@property (nonatomic, strong) GYHSServerDetailAllModel* model;

@property (strong, nonatomic) IBOutlet UILabel* receiverLabel;
@property (strong, nonatomic) IBOutlet UILabel* receiverAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel* receiverContactLabel;
@property (strong, nonatomic) IBOutlet UILabel* sendTimeLabel;

@end
