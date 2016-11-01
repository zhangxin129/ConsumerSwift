//
//  GYHSDetailCheckTimeView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSCunsumeTextField.h"
@class GYHSDetailCheckTimeView;

@protocol GYHSDetailCheckTimeViewChangeDelegate <NSObject>

@optional
/**
 *  代理方法 点击今天 最近一周 查询的方法
 *
 *  @param timeView 自身视图
 */
- (void)clickToday:(GYHSDetailCheckTimeView *)timeView;
- (void)clickWeek:(GYHSDetailCheckTimeView *)timeView;
- (void)clickCheckBtn:(GYHSDetailCheckTimeView *)timeView;
@end

@interface GYHSDetailCheckTimeView : UIView
@property(nonatomic, weak) id <GYHSDetailCheckTimeViewChangeDelegate> delegate;
//设置通常的今天 一周等内容
- (void)setCommonUI;

//设置更简短一点的 今年查询
- (void)setThisYearHeadUI;
@property (nonatomic, weak)  GYHSCunsumeTextField *begainField;
@property (nonatomic, weak)  GYHSCunsumeTextField *endTextfield;
@property (nonatomic, weak)  GYHSCunsumeTextField *endYearTextfield;
@end
