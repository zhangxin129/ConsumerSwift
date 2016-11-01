//
//  GYHSScoreWealImageShowViewController.m
//
//  Created by lizp on 16/10/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//


#import "GYHSScoreWealImageShowViewController.h"
#import "YYKit.h"

@interface GYHSScoreWealImageShowViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *overlay;
@property (nonatomic,weak) UIScrollView *scroll;


@end

@implementation GYHSScoreWealImageShowViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - SystemDelegate  
#pragma mark - UIScrollViewDelegate
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    UIImageView *imageView = scrollView.subviews[0];
    return imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    UIImageView *imageView = scrollView.subviews[0];
    if (scrollView.zoomScale < 1) {
        imageView.center = scrollView.center;
    }else {
        imageView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
    }
    
    
    if (scrollView.zoomScale == 1 ) {
        self.scroll.scrollEnabled = YES;
    }else {
        self.scroll.scrollEnabled = NO;
    }
}



// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate  
#pragma mark - event response  
-(void)tapClick {
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - private methods 
- (void)initView
{

    NSLog(@"Load Controller: %@", [self class]);
    
    [self addOverlayView];
}


//背景
-(void)addOverlayView {
    
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/4, kScreenWidth, kScreenHeight/2 )];
    self.overlay.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.overlay];

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.overlay.bounds];
    scroll.backgroundColor  = kDefaultVCBackgroundColor;
    [self.overlay  addSubview:scroll];
    self.scroll = scroll;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    self.overlay.userInteractionEnabled = YES;
    [self.overlay addGestureRecognizer:tap];
    
    scroll.bounces = NO;
    scroll.pagingEnabled = YES;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < self.arrImg.count; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*scroll.width, 0, scroll.width, scroll.height)];
        view.backgroundColor = kDefaultVCBackgroundColor;
        [scroll addSubview:view];
        
        UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scroll.width, scroll.height)];
        scr.backgroundColor  = kDefaultVCBackgroundColor;
        scr.delegate = self;
        scr.showsHorizontalScrollIndicator = NO;
        scr.showsVerticalScrollIndicator = NO;
        scr.bounces = NO;
        //设置最大伸缩比例
        scr.maximumZoomScale = 2.0;
        //设置最小伸缩比例
        scr.minimumZoomScale = 1;
        [view addSubview:scr];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scroll.width, scroll.height)];
        imageView.backgroundColor = kDefaultVCBackgroundColor;
        [imageView setImageWithURL:[NSURL URLWithString:kSaftToNSString([NSURL URLWithString:self.arrImg[i]])] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
        [scr addSubview:imageView];
    }

    scroll.contentSize = CGSizeMake(self.overlay.width * self.arrImg.count, scroll.height);
    
}

#pragma mark - getters and setters  


@end
