//
//  GYViewControllerDelegate.h
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

// 弹出一个视图的协议

#import <Foundation/Foundation.h>

@protocol GYViewControllerDelegate <NSObject>

@optional
- (void)pushVC:(id)sender animated:(BOOL)ani;
@end
