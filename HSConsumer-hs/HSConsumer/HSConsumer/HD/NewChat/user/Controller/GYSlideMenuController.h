//
//  GYSlideMenuController.h
//  GYSlideMenuController
//
//  Created by QingYi on 15/10/11.
//  Copyright (c) 2015年 QingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MainViewAnimationBlock)(UIView* mainView, CGRect orginFrame, CGFloat xOffset);
typedef NS_ENUM(NSInteger, SlideAnimationType) {
    SlideAnimationTypeScale,
    SlideAnimationTypeMove
};
@interface GYSlideMenuController : GYViewController

@property (assign, nonatomic) BOOL needSwipeShowMenu;
@property (assign, nonatomic) BOOL needShowBoundsShadow;
@property (assign, nonatomic) BOOL needPanFromViewBounds;

@property (strong, nonatomic) UIViewController* mainViewController;
@property (strong, nonatomic) UIViewController* leftViewController;
@property (strong, nonatomic) UIViewController* rightViewController;

@property (assign, nonatomic) CGFloat leftViewShowWidth;
@property (assign, nonatomic) CGFloat rightViewShowWidth;
@property (assign, nonatomic) NSTimeInterval animationDuration;

@property (copy, nonatomic) MainViewAnimationBlock mainViewAnimationBlock;
@property (assign, nonatomic) SlideAnimationType animationType;

- (instancetype)initWithMainViewController:(UIViewController*)main leftViewController:(UIViewController*)left rightViewController:(UIViewController*)right animationBlock:(MainViewAnimationBlock)block;
- (void)showLeftViewController:(BOOL)animated;
- (void)showRightViewController:(BOOL)animated;
- (void)hideSlideMenuViewController:(BOOL)animated;

@end
