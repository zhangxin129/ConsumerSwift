//
//  GYSelectPayWayViewController.h
//  HSConsumer
//
//  Created by 00 on 14-11-4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
//选择支付方式代理
@protocol GYSelectPayWayDelegate <NSObject>

//-(void)getBackPayWay:(NSString *)str;
- (void)getBackPayWay:(int)payType;
@end

@interface GYSelectPayWayViewController : GYViewController
@property (weak, nonatomic) id<GYSelectPayWayDelegate> delegate;
@property (strong, nonatomic) NSArray* arrData;
@property (assign, nonatomic) int selectIndex;

@end
