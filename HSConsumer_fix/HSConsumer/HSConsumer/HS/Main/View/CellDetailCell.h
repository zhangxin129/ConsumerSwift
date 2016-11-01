//
//  CellDetailCell.h
//  HSConsumer
//
//  Created by apple on 14-10-31.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//明细查询基类的cell

#define kCellDetailCellIdentifier @"CellDetailCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* lbRow1Left; //积分投资a
@property (strong, nonatomic) IBOutlet UILabel* lbRow1Right; //2014-10-10aa
@property (strong, nonatomic) IBOutlet UILabel* lbRow2Left; //投资金额b
@property (strong, nonatomic) IBOutlet UILabel* lbRow2Right; //1.00bb
@property (strong, nonatomic) IBOutlet UILabel* lbRow3Left; //状态c
@property (strong, nonatomic) IBOutlet UILabel *lbRow3Right;//交易成功cc

@end
