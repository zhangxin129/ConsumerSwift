//
//  CellDetailRow.h
//  HSConsumer
//
//  Created by apple on 14-10-31.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//明细查询基类的cell

#define kCellDetailRowIdentifier @"CellDetailRowIdentifier"

#import <UIKit/UIKit.h>

@interface CellDetailRow : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* lbTitle; //业务流水号
@property (strong, nonatomic) IBOutlet UILabel *lbValue;


@end
