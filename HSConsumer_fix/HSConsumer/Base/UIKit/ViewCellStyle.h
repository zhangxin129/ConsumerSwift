//
//  ViewCellStyle.h
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//各账户下功能共公的view

#import <UIKit/UIKit.h>

@interface ViewCellStyle : UIControl

@property (strong, nonatomic) IBOutlet UIImageView* ivTitle; //cell的图标
@property (strong, nonatomic) IBOutlet UILabel* lbActionName; //功能名称
@property (strong, nonatomic) NSString *nextVcName;   //下一个VC

@end
