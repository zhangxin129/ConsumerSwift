//
//  GYHSServerOrderCell.h
//  HSConsumer
//
//  Created by kuser on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSServerOrderCellModel;

@interface GYHSServerOrderCell : UITableViewCell

@property (nonatomic, strong) GYHSServerOrderCellModel* model;
@property (strong, nonatomic) IBOutlet UIImageView* urlIcon; //图标
@property (strong, nonatomic) IBOutlet UILabel* titleLabel; //标题
@property (strong, nonatomic) IBOutlet UILabel* detailTimeLabel; //详细时间
@property (strong, nonatomic) IBOutlet UILabel* orderIdLabel; //订单号
@property (strong, nonatomic) IBOutlet UILabel* timeLabel; //预约时间
@property (strong, nonatomic) IBOutlet UILabel* priceLabel; //金额
@property (strong, nonatomic) IBOutlet UILabel* pvLabel; //积分
@property (strong, nonatomic) IBOutlet UIButton* confirmBtn; //确认服务按钮
@property (strong, nonatomic) IBOutlet UIButton* otherBtn; //退款，取消，再订按钮
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* timeLabelDistanceTopConstraint; //详细时间距离顶部距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* orderIDDistanceRightConstraint; //订单号距离顶部距离

@end
