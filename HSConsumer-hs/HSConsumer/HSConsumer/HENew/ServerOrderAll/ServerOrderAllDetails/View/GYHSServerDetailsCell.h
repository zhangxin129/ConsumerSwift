//
//  GYHSServerDetailsCell.h
//  HSConsumer
//
//  Created by zhengcx on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSServerOrderDetailsCellModel;

@interface GYHSServerDetailsCell : UITableViewCell

@property (nonatomic, strong) GYHSServerOrderDetailsCellModel* model;

@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UILabel* pvLabel;
@property (strong, nonatomic) IBOutlet UILabel* priceLabel;
@property (strong, nonatomic) IBOutlet UILabel* countLabel;

@end
