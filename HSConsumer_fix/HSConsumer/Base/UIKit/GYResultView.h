//
//  GYResultView.h
//  company
//
//  Created by Apple03 on 15-4-25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYResultView;

@protocol GYResultViewDelegate <NSObject>
@optional
- (void)ResultViewConfrimButtonClicked:(GYResultView*)ResultView success:(BOOL)success;

@end

@interface GYResultView : UIView
@property (nonatomic, copy) NSString* strResultInfo;
@property (nonatomic, assign) BOOL bSuccess;

@property (nonatomic, weak) id<GYResultViewDelegate> delegate;

- (void)show;
- (void)showWithView:(UIView*)view status:(BOOL)bStatus message:(NSString*)message;
@end
