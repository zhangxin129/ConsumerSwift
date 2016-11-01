//
//  GYDynamicMenuView.h
//  GYDynamicMenu
//
//  Created by xiaoxh on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYDynamicMenuViewDelegate <NSObject>

-(void)imageIndex:(NSInteger)index;

@end
@interface GYDynamicMenuView : UIView
-(id)initWithBtn:(UIButton*)btn;
-(void)show;
@property (nonatomic, weak)id<GYDynamicMenuViewDelegate> menuViewDelegate;
@end
