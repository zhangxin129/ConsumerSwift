//
//  GYHSTakeAwayAddressCell.h
//  HSConsumer
//
//  Created by kuser on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSTakeAwayDetailAllModel;

@interface GYHSTakeAwayAddressCell : UITableViewCell

@property (nonatomic, strong) GYHSTakeAwayDetailAllModel* model;

@property (strong, nonatomic) IBOutlet UILabel* receiverLabel; //联系人
@property (strong, nonatomic) IBOutlet UILabel* receiverContactLabel; //电话
@property (strong, nonatomic) IBOutlet UILabel* receiverAddressLabel; //地址
@property (strong, nonatomic) IBOutlet UILabel* receiveTimeLabel; //期望收货时间

@end
