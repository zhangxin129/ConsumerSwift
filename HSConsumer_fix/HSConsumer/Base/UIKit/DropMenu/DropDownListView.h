//
//  DropDownListView.h
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownListViewDelegate <NSObject>

@optional
- (void)menuDidSelectIsChange:(BOOL)isChange withObject:(id)sender;

@end

@interface DropDownListView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isHideBackground;
@property (nonatomic, assign) id<DropDownListViewDelegate> delegate;

- (id)initWithArray:(NSArray*)array parentView:(UIView*)superView widthSenderFrame:(CGRect)f;
- (BOOL)isShow;
- (void)hideExtendedChooseView;
- (void)showChooseListView;

@end
