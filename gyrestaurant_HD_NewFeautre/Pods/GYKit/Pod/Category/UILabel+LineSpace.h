//
//  UILabel+LineSpace.h
//  company
//
//  Created by apple on 14-11-10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LineSpace)
//设置行间距的方法
-(void)setLineSpace : (CGFloat)spaceCout WithLabel :(UILabel *) label  WithText:(NSString *)text;
@end
