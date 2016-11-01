//
//  GYGoodDetailListTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYGoodDetailListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* lbDetailTitle;
@property (weak, nonatomic) IBOutlet UILabel* lbDetailInfo;
- (void)refreshUIWith:(NSString*)title WithDetail:(NSString*)detail;
@end
