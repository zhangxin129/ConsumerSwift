//
//  GYHSPointInputView.h
//
//  Created by apple on 16/7/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GYTextField;
@protocol GYHSPointInputDelegate <NSObject>
@optional
- (void)clickRightAction:(NSInteger)index;

@end
@interface GYHSPointInputView : UIView
@property (nonatomic, strong) GYTextField* textfield;
@property (nonatomic, assign) BOOL isShowRightView;
@property (nonatomic, weak) id<GYHSPointInputDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName placeholder:(NSString*)placeholder;
@end
