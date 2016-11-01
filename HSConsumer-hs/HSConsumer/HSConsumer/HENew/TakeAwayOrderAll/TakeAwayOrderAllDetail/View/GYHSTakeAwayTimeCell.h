//
//  GYHSTakeAwayTimeCell.h
//  HSConsumer
//
//  Created by kuser on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSTakeAwayDetailAllModel;

@interface GYHSTakeAwayTimeCell : UITableViewCell

@property (nonatomic, strong) GYHSTakeAwayDetailAllModel* model;

@property (strong, nonatomic) IBOutlet UILabel* trandsFinishLabel; //交易完成
@property (strong, nonatomic) IBOutlet UILabel* receiveOrderLabel; //接单
@property (strong, nonatomic) IBOutlet UILabel* confirmServerLabel; //确认服务
@property (strong, nonatomic) IBOutlet UILabel* alreadyCommitOrderLabel; //已提单
@property (strong, nonatomic) IBOutlet UILabel* alreadyReceiveTimeLabel; //接单
@property (strong, nonatomic) IBOutlet UILabel* alreadyServerLabel; //已服务
@property (strong, nonatomic) IBOutlet UIButton* backGroundBlueBtn; //头部背景蓝色
@property (strong, nonatomic) IBOutlet UIView* lineView;

@end
