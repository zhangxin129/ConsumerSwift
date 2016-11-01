//
//  WealCheckCell.h
//  HSConsumer
//
//  Created by 00 on 15-3-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WealCheckCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* row1R;
@property (weak, nonatomic) IBOutlet UILabel* row2R;
@property (weak, nonatomic) IBOutlet UILabel* row3R;
@property (weak, nonatomic) IBOutlet UILabel* row4R;
@property (weak, nonatomic) IBOutlet UILabel* row5R;
@property (weak, nonatomic) IBOutlet UILabel* queryDetailsLabel; //查看详情

@property (weak, nonatomic) IBOutlet UILabel* orderLb;

@property (weak, nonatomic) IBOutlet UILabel* timeLb;

@property (weak, nonatomic) IBOutlet UILabel* typeLb;

@property (weak, nonatomic) IBOutlet UILabel* resultLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;

@end
