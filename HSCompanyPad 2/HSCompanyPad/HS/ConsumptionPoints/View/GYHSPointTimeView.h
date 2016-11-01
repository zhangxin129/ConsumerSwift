//
//  GYHSPointTimeView.h
//
//  Created by apple on 16/8/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GYHSCunsumeTextField;
@protocol GYHSPointTimeDelegate <NSObject>
@optional
- (void)checkWithPerNo:(NSString *)perResNO startDate:(NSString *)startDate endDate:(NSString *)endDate;
- (void)getScanWithNumber;
@end
@interface GYHSPointTimeView : UIView
@property (nonatomic, weak) GYHSCunsumeTextField* cardField;
@property (nonatomic, weak) GYHSCunsumeTextField* begainField;
@property (nonatomic, weak) GYHSCunsumeTextField* endTextfield;
@property (nonatomic,weak) id<GYHSPointTimeDelegate> delegate;
@end
