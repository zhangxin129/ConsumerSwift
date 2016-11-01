//
//  GYMenuTabView.h
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYMenuTabView;
@protocol GYMenuTabViewDelegate <NSObject>

- (void)menuTabView:(GYMenuTabView *)menuTabView didClickTitleAtIndex:(NSInteger)index;
@end

@interface GYMenuTabView : UIView

@property (nonatomic, weak) UIViewController<GYMenuTabViewDelegate> *delegate;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger selectIndex;
@end
