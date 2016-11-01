//
//  GYHSTakeAwayDetailsCell.h
//  HSConsumer
//
//  Created by kuser on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSTakeAwayOrderDetailsCellModel;

@interface GYHSTakeAwayDetailsCell : UITableViewCell

@property (nonatomic, strong) GYHSTakeAwayOrderDetailsCellModel* model;

@property (strong, nonatomic) IBOutlet UILabel* titleLabel; //名字
@property (strong, nonatomic) IBOutlet UILabel* priceLabel; //价格
@property (strong, nonatomic) IBOutlet UILabel* pvLabel; //积分
@property (strong, nonatomic) IBOutlet UILabel* countLabel; //数量

@end
