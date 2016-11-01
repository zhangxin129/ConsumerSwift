//
//  CellShowBtDevicesCell.h
//  company
//
//  Created by liangzm on 15-4-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYPOSCardReaderShowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* ivCellImage; //cell的图标
@property (weak, nonatomic) IBOutlet UILabel* lbCellLabel; //cell 左 label
@property (weak, nonatomic) IBOutlet UILabel* lbCellStateLabel; //cell 右 label

@end
