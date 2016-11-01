//
//  GYOrderandStateCellT.h
//  HSConsumer
//
//  Created by appleliss on 15/9/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GYOrderandStateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* lbTitle; ////title
@property (weak, nonatomic) IBOutlet UILabel* lbOrder; ///订单号
@property (weak, nonatomic) IBOutlet UILabel* lbOrderState; ///订单状态
@end
