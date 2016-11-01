//
//  GYNewDataCalendarViewController.h
//  HSConsumer
//
//  Created by appleliss on 15/12/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
@protocol GYNewDataCalendarViewControllerDelegate <NSObject>
- (void)updateDate:(NSString*)value andDatemark:(int)datemark andTimemark:(int)timemark;

@end
#import <UIKit/UIKit.h>

@interface GYNewDataCalendarViewController : GYViewController
@property (nonatomic, strong) NSArray* dataTimes;
@property (nonatomic, strong) NSArray* dataTimesNoShop;
@property (nonatomic, weak) id<GYNewDataCalendarViewControllerDelegate> gynewDataCalendarDelegate;
@property (nonatomic, assign) int datemark;
@property(nonatomic, assign) int timemark;
@end
