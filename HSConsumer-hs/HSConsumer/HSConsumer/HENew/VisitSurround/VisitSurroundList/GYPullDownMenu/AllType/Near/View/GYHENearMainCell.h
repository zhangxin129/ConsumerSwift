//
//  GYHENearMainCell.h
//  HSConsumer
//
//  Created by zhengcx on 16/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHENearModel.h"

@interface GYHENearMainCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;

@property(nonatomic,strong)GYHENearModel *model;

@end
