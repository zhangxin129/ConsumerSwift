//
//  GYHEMiddleViewFirstCell.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEMiddleViewFirstCell : UITableViewCell
//物品名称
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//物品价格
@property (weak, nonatomic) IBOutlet UILabel *cashValueLabel;

//积分数量
@property (weak, nonatomic) IBOutlet UILabel *pvValueLabel;
//计入数量
@property (weak, nonatomic) IBOutlet UILabel *numbelLabel;




@end
