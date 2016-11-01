//
//  GYHSTakeAwayOrderCell.h
//  HSConsumer
//
//  Created by kuser on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class GYHSTakeAwayOrderCellModel;
@class GYHSTakeAwayModels;

@interface GYHSTakeAwayOrderCell : UITableViewCell

@property (nonatomic, strong) GYHSTakeAwayModels* model;
//图标
@property (strong, nonatomic) IBOutlet UIImageView* urlIcon;
//标题
@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
//详细时间
@property (strong, nonatomic) IBOutlet UILabel* detailTimeLabel;
//订单号
@property (strong, nonatomic) IBOutlet UILabel* orderIdLabel;
//金额
@property (strong, nonatomic) IBOutlet UILabel* priceLabel;
//积分
@property (strong, nonatomic) IBOutlet UILabel* pvLabel;
//确认服务按钮
@property (strong, nonatomic) IBOutlet UIButton* confirmBtn;
//退款，取消，再订按钮
@property (strong, nonatomic) IBOutlet UIButton* otherBtn;

@end
