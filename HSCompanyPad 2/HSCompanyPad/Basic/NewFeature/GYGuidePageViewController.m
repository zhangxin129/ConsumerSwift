//
//  GYGuidePageViewController.m
//  HSEnterprise
//
//  Created by zhangqy on 15/12/30.
//  Copyright © 2015年 guiyi. All rights reserved.
//

#import "GYGuidePageViewController.h"


@interface GYGuidePageViewController ()

@end

@implementation GYGuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*3, [UIScreen mainScreen].bounds.size.height);
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.pagingEnabled=YES;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
    }];
    NSArray * imgArr=@[@"welcome_01",@"welcome_02",@"welcome_03"];
    NSArray * pointArr =@[@"welcome_point1",@"welcome_point2",@"welcome_point3"];
    
    
    for(int i=0;i<3;i++)
    {
        UIImageView *imgView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:imgArr[i]]];
        imgView.frame=CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [scrollView addSubview:imgView];
        
        UIImageView *point =[[UIImageView alloc] initWithImage:[UIImage imageNamed:pointArr[i]]];
        [scrollView addSubview:point];
        [point mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(10);
            make.bottom.equalTo(imgView).with.offset(-60);
            make.centerX.equalTo(imgView);
        }];
       
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"welcome_jump"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(20);
            make.trailing.equalTo(imgView).with.offset(-40);
            make.top.equalTo(imgView).with.offset(80);
        }];
        
        if(i==2)
        {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"welcome_HS"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(150);
                make.height.mas_equalTo(50);
                make.bottom.equalTo(imgView).with.offset(-120);
                make.centerX.equalTo(imgView);
            }];
        }
        
    }
    
    
}
//进入登录控制器
-(void)jump
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    kAppDelegate.window.rootViewController = [storyBoard instantiateInitialViewController];
}




@end
