//
//  GYGeneralTableViewCell.h
//  HSConsumer
//
//  Created by 00 on 14-10-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYGeneralTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* lbTitle; //标题
@property (weak, nonatomic) IBOutlet UIImageView* imgRightArrow; //箭头tup
@property (weak, nonatomic) IBOutlet UILabel* lbVersions; //版本号
@property (weak, nonatomic) IBOutlet UIImageView* iconImageView; //图标
@property (weak, nonatomic) IBOutlet UILabel* languageLabel; //语言文字

@end
