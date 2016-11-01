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
//#import "UIView+Frame.h"
#import "AppDelegate.h"
#import "GYLoginViewController.h"
#import "GYNavigationController.h"

#define GYNewFeatureCount 3
#define APPDELEGATE     ((AppDelegate*)[UIApplication sharedApplication].delegate)
#define KGetNowY (self.view.height - 20)
@interface GYNewFeatureViewController()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

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



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建scorollView
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    
    //scorollView属性设置
    scrollView.frame = self.view.bounds ;
    scrollView.contentSize = CGSizeMake(GYNewFeatureCount * self.view.width, self.view.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    //设置代理
    scrollView.delegate = self;
    
    //添加新属性图片视图
    for (int i = 0; i < GYNewFeatureCount; i++) {
        
        NSString *imageName = nil;
        //获取屏幕分辨率
        CGRect rect_screen = [[UIScreen mainScreen]bounds];
        CGSize size_screen = rect_screen.size;
        
        CGFloat scale_screen = [UIScreen mainScreen].scale;
        
        CGFloat width = size_screen.width*scale_screen;
   //     CGFloat height = size_screen.height*scale_screen;
        if (width == 2048) {
            imageName = [NSString stringWithFormat:@"%d-2048.png",i+1];
        }else if(width == 1024) {
            imageName =[NSString stringWithFormat:@"%d-1024.png",i+1];
        }else if (width == 2732){
            imageName =[NSString stringWithFormat:@"%d-2732.png",i+1];
        
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = self.view.bounds;
        imageView.x = i * imageView.width;
        
        //如果是最后一页，需要添加按钮
        if (i == GYNewFeatureCount - 1) {
            [self setupLastPage:imageView];
        }
        
        [scrollView addSubview:imageView];
    }
    
    
    
    //设置页码视图
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = GYNewFeatureCount;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = kRedFontColor;
    pageControl.centerX = self.view.centerX ;
    pageControl.centerY = KGetNowY;
    self.pageControl = pageControl;
    
    
    [self.view addSubview:scrollView];
    
    UIButton *passBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 20 - 57, 20, 57 , 30)];
    [passBtn setBackgroundImage:[UIImage imageNamed:@"jump"] forState:UIControlStateNormal];
    //添加跳出按钮的监听事件
    [passBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passBtn];
    [self.view addSubview:pageControl];
    
    // ios6的时候 隐藏statusbar底部会出现白条 所有都不隐藏
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

/**
 *  设置最后一页的按钮
 *
 */
- (void)setupLastPage: (UIImageView *)imageView
{
    
    //开启交互功能
    imageView.userInteractionEnabled = YES;
    
    
    //设置开始按钮
    UIButton *startBtn = [[UIButton alloc]init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
    startBtn.size = CGSizeMake(150, 50);
    startBtn.centerX = self.view.centerX;
    startBtn.centerY = KGetNowY - 56 - 5;
    
    //添加开始按钮的监听事件
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:startBtn];
}

- (void)startClick
{
    GYLoginViewController * ctl = [[GYLoginViewController alloc]init];
    GYNavigationController  *nvc = [[GYNavigationController alloc]initWithRootViewController:ctl];
    APPDELEGATE.window.rootViewController = nvc;
     
}


#pragma mark - 实现scrollView的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //设置页数
    double page = scrollView.contentOffset.x /scrollView.width ;
    
    self.pageControl.currentPage = (int)(page + 0.5);
    
}

- (BOOL)shouldAutorotate

{
    
    return YES;
    
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    
    return UIInterfaceOrientationMaskLandscape;
    
    
}


@end
