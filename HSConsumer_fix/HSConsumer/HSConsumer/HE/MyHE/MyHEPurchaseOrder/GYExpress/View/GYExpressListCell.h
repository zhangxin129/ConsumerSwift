//
//  GYExpressListCell.h
//  HSConsumer
//
//  Created by apple on 16/3/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYExpressModel.h"
@interface GYExpressListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* expressLabel; //快递单号
@property (weak, nonatomic) IBOutlet UIImageView* isSelectImageView; //是否选择
- (void)refreshUIWithModel:(GYExpressModel *)model;
@end
