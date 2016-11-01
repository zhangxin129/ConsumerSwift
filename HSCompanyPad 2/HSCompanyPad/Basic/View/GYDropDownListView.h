//
//  GYDropDownListView.h
//  HSCompanyPad
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYDropDownListViewDelegate <NSObject>

@optional
- (void)menuDidSelectIsChange:(BOOL)isChange withObject:(id)sender;

@end


@interface GYDropDownListView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isHideBackground;
@property (nonatomic, assign) id<GYDropDownListViewDelegate> delegate;

- (id)initWithArray:(NSArray*)array parentView:(UIView*)superView widthSenderFrame:(CGRect)f;
- (BOOL)isShow;
- (void)hideExtendedChooseView;
-(void)showChooseListView;

@end
