//
//  GYAroundLocationHeadView.h
//  HSConsumer
//
//  Created by Apple03 on 15/11/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYAroundLocationHeadView;
@protocol AroundLocationHeadViewDelegate <NSObject>
@optional
- (void)AroundLocationHeadView:(GYAroundLocationHeadView*)view didChooseCity:(NSString*)city;

@end

@interface GYAroundLocationHeadView : UIView
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray* arrData;
- (void)reloadData;

@property (nonatomic, weak) id<AroundLocationHeadViewDelegate> delegate;
@end
