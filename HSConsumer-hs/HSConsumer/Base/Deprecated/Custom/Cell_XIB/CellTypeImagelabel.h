//
//  CellTypeImagelabel.h
//  company
//
//  Created by apple on 14-11-12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kCellTypeImagelabelIdentifier @"CellTypeImagelabelIdentifier"

#import <UIKit/UIKit.h>

@interface CellTypeImagelabel : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView* ivCellImage; //cell的图标
@property (strong, nonatomic) IBOutlet UIImageView* ivCellRightArrow; //cell右箭头

@property (strong, nonatomic) IBOutlet UILabel* lbCellLabel; //cell label

@end
