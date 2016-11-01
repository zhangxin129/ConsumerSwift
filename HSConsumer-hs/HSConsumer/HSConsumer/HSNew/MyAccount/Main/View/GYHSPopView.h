//
//  GYHSPopView.h
//  HSConsumer
//
//  Created by kuser on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSPopView;

@protocol GYHSPopViewDelegate <NSObject>

@optional
- (void)disMissBtnClickDelegate;

@end

@interface GYHSPopView : UIView

@property (nonatomic, strong) UIButton* closeBtn;
@property (nonatomic, strong) UIView* popView;

@property (nonatomic, weak) id<GYHSPopViewDelegate> delegate;

@property (nonatomic, assign) BOOL hiddenCloseBtn;

//用于初始化控件
- (void)showView;
- (void)showView:(UIViewController*)vc;
- (void)showView:(UIViewController*)vc withViewFrame:(CGRect)viewFrame;
- (void)showViews:(UIViewController*)vc withViewFrame:(CGRect)viewFrames;
- (void)dismissViewPop;

@end
