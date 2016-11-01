//
//  GYNewFeatureViewController.m
//  GYCompany
//
//  Created by cook on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYNewFeatureViewController.h"
#import "UIView+Extension.h"
#import "GYAppDelegate.h"
#import "CALayer+Transition.h"
#import "GYHDUserSetingViewController.h"
#import "GYSlideMenuController.h"
#import "GYTabBarController.h"
#define GYNewFeatureCount 3
#define APPDELEGATE ((GYAppDelegate*)[UIApplication sharedApplication].delegate)
#define KGetNowY (self.view.height - 20)
@interface GYNewFeatureViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView* scrollView;
@property (nonatomic, weak) UIPageControl* pageControl;

@end

@implementation GYNewFeatureViewController
/**
 *  隐藏状态栏
 *
 */

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //创建scorollView
    UIScrollView* scrollView = [[UIScrollView alloc] init];

    //scorollView属性设置
    scrollView.frame = self.view.bounds;
    scrollView.contentSize = CGSizeMake(GYNewFeatureCount * self.view.width, self.view.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;

    //设置代理
    scrollView.delegate = self;

    NSString* defaultHeight = @"480";
    if (kScreenHeight == 480) {
        defaultHeight = @"480";
    }
    else if (kScreenHeight == 568) {
        defaultHeight = @"568";
    }
    else if (kScreenHeight == 667) {
        defaultHeight = @"667";
    }
    else if (kScreenHeight == 736) {
        defaultHeight = @"736";
    }

    //添加新属性图片视图
    for (int i = 0; i < GYNewFeatureCount; i++) {

        NSString* imageName = nil;
        imageName = [NSString stringWithFormat:@"gycommon_default%d-%@", i + 1, defaultHeight];

        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = self.view.bounds;
        imageView.x = i * imageView.width;

        //如果是最后一页，需要添加按钮
        if (i == GYNewFeatureCount - 1) {
            [self setupLastPage:imageView];
        }

        [scrollView addSubview:imageView];
    }

    //设置页码视图
    UIPageControl* pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = GYNewFeatureCount;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = kNavigationBarColor;
    pageControl.centerX = self.view.centerX;
    pageControl.centerY = KGetNowY;
    self.pageControl = pageControl;

    [self.view addSubview:scrollView];

    UIButton* passBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 20 - 50, 10, 72, 72)];
    [passBtn setImage:[UIImage imageNamed:@"gyhe_btn_pass"] forState:UIControlStateNormal];
    [passBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 14, 0)];
    //添加跳出按钮的监听事件
    [passBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passBtn];
    [self.view addSubview:pageControl];
}

/**
 *  设置最后一页的按钮
 *
 */
- (void)setupLastPage:(UIImageView*)imageView
{

    //开启交互功能
    imageView.userInteractionEnabled = YES;

    //设置开始按钮
    UIButton* startBtn = [[UIButton alloc] init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_btn_now_get"] forState:UIControlStateNormal];
    startBtn.size = CGSizeMake(88, 28);
    startBtn.centerX = self.view.centerX;
    startBtn.centerY = KGetNowY - 28 - 5;

    //添加开始按钮的监听事件
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];

    [imageView addSubview:startBtn];
}

- (void)startClick
{
    GYHDUserSetingViewController* leftView = [[GYHDUserSetingViewController alloc] init];

    globalData.viewController = [[GYSlideMenuController alloc] init];
    globalData.viewController.mainViewController = [[GYTabBarController alloc] init];
    globalData.viewController.leftViewController = leftView;
    APPDELEGATE.window.rootViewController = globalData.viewController;
    [APPDELEGATE.window.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.5f];
}

#pragma mark - 实现scrollView的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //设置页数
    double page = scrollView.contentOffset.x /scrollView.width;

    self.pageControl.currentPage = (int)(page + 0.5);

}

@end
