//
//  GYSelectLanguageCell.h
//  HSConsumer
//
//  Created by kuser on 16/3/7.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYSelectLanguageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* languageImageView; //图标
@property (weak, nonatomic) IBOutlet UILabel* titleLabel; //语言文字
@property (weak, nonatomic) IBOutlet UIImageView* confirmImageView; //打钩图标

@end
