//
//  GYHDAttentionCompanyViewController.m
//  HSConsumer
//
//  Created by shiang on 16/3/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAttentionCompanyViewController.h"
#import "GYHDAttentionNameSearchViewController.h"
#import "GYHDAttentionCitySearchViewController.h"
#import "GYHDMessageCenter.h"
#import "UIView+Extension.h"

@interface GYHDAttentionCompanyViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
/**互生搜索控制器*/
@property (nonatomic, strong) GYHDAttentionNameSearchViewController* attentionNameViewController;
/**城市搜索控制器*/
@property (nonatomic, strong) GYHDAttentionCitySearchViewController* attentionCityViewController;
/**互生搜索按钮*/
@property (nonatomic, weak) UIButton* AttentionHushengNameButton;
/**城市搜索按钮*/
@property (nonatomic, weak) UIButton* AttentionCityButton;
@property (nonatomic, weak) UIPageViewController* pageViewController;
@end

@implementation GYHDAttentionCompanyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 标题
    self.title = [GYUtils localizedStringWithKey:@"GYHD_user_tttentionCompany"];
    // 搜索名字按钮
    UIButton* AttentionHushengNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [AttentionHushengNameButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [AttentionHushengNameButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_attentionHusheng_search"] forState:UIControlStateNormal];
    [AttentionHushengNameButton setBackgroundImage:[UIImage imageNamed:@"gyhd_attention_company_tab_left"] forState:UIControlStateNormal];
    [AttentionHushengNameButton setBackgroundImage:[UIImage imageNamed:@"gyhd_attention_company_tab_left_tap"] forState:UIControlStateSelected];
    AttentionHushengNameButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24.0f)];
    [AttentionHushengNameButton setTitleColor:[UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1] forState:UIControlStateNormal];
    [AttentionHushengNameButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.view addSubview:AttentionHushengNameButton];
    _AttentionHushengNameButton = AttentionHushengNameButton;
    // 搜索城市按钮
    UIButton* AttentionCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [AttentionCityButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [AttentionCityButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_attentionCity_search"] forState:UIControlStateNormal];
    [AttentionCityButton setBackgroundImage:[UIImage imageNamed:@"gyhd_attention_company_tab_mid"] forState:UIControlStateNormal];
    [AttentionCityButton setBackgroundImage:[UIImage imageNamed:@"gyhd_attention_company_tab_mid_tap"] forState:UIControlStateSelected];
    AttentionCityButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24.0f)];
    [AttentionCityButton setTitleColor:[UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1] forState:UIControlStateNormal];
    [AttentionCityButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.view addSubview:AttentionCityButton];
    _AttentionCityButton = AttentionCityButton;

    /**城市搜索控制器*/
    GYHDAttentionCitySearchViewController* attentionCityViewController = [[GYHDAttentionCitySearchViewController alloc] init];
    _attentionNameViewController.view.frame = self.view.bounds;

    _attentionCityViewController = attentionCityViewController;
    // 搜素名字控制器
    GYHDAttentionNameSearchViewController* attentionNameViewController = [[GYHDAttentionNameSearchViewController alloc] init];
    _attentionNameViewController.view.frame = self.view.bounds;

    _attentionNameViewController = attentionNameViewController;

    UIPageViewController* pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    _pageViewController = pageViewController;
    [pageViewController setViewControllers:@[ attentionNameViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    self.AttentionHushengNameButton.selected = YES;
    //    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [backButton setImage:[UIImage imageNamed:@"gyhd_nav_leftView_back"] forState:UIControlStateNormal];
    //    backButton.frame = CGRectMake(0, 0, 80, 40);
    //    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0);
    //    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    WS(weakSelf);
    [self.AttentionHushengNameButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.mas_equalTo(0);
        make.right.equalTo(weakSelf.AttentionCityButton.mas_left);
        make.height.mas_equalTo(32.0f);
        make.width.equalTo(weakSelf.AttentionCityButton);
    }];
    [self.AttentionCityButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.right.mas_equalTo(0);
        make.left.equalTo(weakSelf.AttentionHushengNameButton.mas_right);
        make.height.mas_equalTo(32.0f);
        make.width.equalTo(weakSelf.AttentionHushengNameButton);
    }];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.AttentionHushengNameButton.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController*)pageViewController
{
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController*)pageViewController
{
    return 0;
}

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[GYHDAttentionCitySearchViewController class]]) {
        return self.attentionNameViewController;
    }
    return nil;
}

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[GYHDAttentionNameSearchViewController class]]) {
        return self.attentionCityViewController;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController*)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController*>*)previousViewControllers transitionCompleted:(BOOL)completed
{
    if ([previousViewControllers.lastObject isKindOfClass:[GYHDAttentionNameSearchViewController class]]) {
        self.AttentionCityButton.selected = YES;
        self.AttentionHushengNameButton.selected = NO;
    }
    else if ([previousViewControllers.lastObject isKindOfClass:[GYHDAttentionCitySearchViewController class]]) {
        self.AttentionCityButton.selected = NO;
        self.AttentionHushengNameButton.selected = YES;
    }
}

- (void)buttonClick:(UIButton*)button
{

    if ([button isEqual:self.AttentionHushengNameButton]) {
        self.AttentionCityButton.selected = NO;
        self.AttentionHushengNameButton.selected = YES;
        [self.pageViewController setViewControllers:@[ self.attentionNameViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    else if ([button isEqual:self.AttentionCityButton]) {
        self.AttentionCityButton.selected = YES;
        self.AttentionHushengNameButton.selected = NO;
        [self.pageViewController setViewControllers:@[ self.attentionCityViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor redColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"gyhd_nav_leftView_back"] forState:UIControlStateNormal];
//    backButton.frame = CGRectMake(0, 0, 80, 40);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
//    [backButton addTarget:self action:@selector(ignoreClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

//}
//- (void)ignoreClick {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barTintColor = kNavBackgroundColor;
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//}
@end
