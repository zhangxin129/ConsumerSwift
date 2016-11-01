//
//  GYHSLoginMainVC.m
//  HSConsumer
//
//  Created by wangfd on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginMainVC.h"
#import "MenuTabView.h"
#import "GYHSLoginViewController.h"
#import "Masonry.h"

@interface GYHSLoginMainVC () <MenuTabViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray* menuDataAry;
@property (nonatomic, strong) MenuTabView* menuView;
@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic, strong) GYHSLoginViewController* hsUserVC;
@property (nonatomic, strong) GYHSLoginViewController* noCardUserVC;

@end

@implementation GYHSLoginMainVC

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

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    [self.view endEditing:YES];

    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
    if (viewIndex == index) {
        return;
    }

    CGFloat startX = self.scrollView.frame.size.width * index;
    [self.scrollView scrollRectToVisible:CGRectMake(startX,
                                             self.scrollView.frame.origin.y,
                                             self.scrollView.frame.size.width,
                                             self.scrollView.frame.size.height)
                                animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    CGFloat _x = scrollView.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(_x / self.view.frame.size.width);

    if (viewIndex < self.menuView.selectedIndex) {
        if (_x < self.menuView.selectedIndex * self.view.frame.size.width - 0.5 * self.view.frame.size.width) {
            [self.menuView updateMenu:viewIndex];
        }
    }
    else if (viewIndex == self.menuView.selectedIndex) {
        if (_x > self.menuView.selectedIndex * self.view.frame.size.width + 0.5 * self.view.frame.size.width) {
            [self.menuView updateMenu:viewIndex + 1];
        }
    }
    else {
        [self.menuView updateMenu:viewIndex];
    }
}

#pragma mark - private methods
- (void)initView
{
    self.title = @"";
    self.view.backgroundColor = kDefaultVCBackgroundColor;

    [self.view addSubview:self.menuView];
    [self.view addSubview:self.scrollView];

    [self.menuView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
    }];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(self.view.frame.size.height);
        make.width.mas_equalTo(self.view.frame.size.width);
    }];

    self.hsUserVC.view.frame = self.scrollView.bounds;
    [self addChildViewController:self.hsUserVC];
    [self.scrollView addSubview:self.hsUserVC.view];

    CGRect vFrame = self.scrollView.bounds;
    vFrame.origin.x += self.view.frame.size.width;
    self.noCardUserVC.view.frame = vFrame;
    [self addChildViewController:self.noCardUserVC];
    [self.scrollView addSubview:self.noCardUserVC.view];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGRect vFrame = self.scrollView.bounds;
    vFrame.origin.x = self.view.frame.size.width;
    self.noCardUserVC.view.frame = vFrame;
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width * [self.menuDataAry count], self.view.frame.size.height - 40)];
}

#pragma mark - getter and setter
- (NSMutableArray*)menuDataAry
{
    if (_menuDataAry == nil) {
        _menuDataAry = [NSMutableArray array];
        [_menuDataAry addObject:kLocalized(@"持互生卡用户登录")];
        [_menuDataAry addObject:kLocalized(@"非持卡用户登录/注册")];
    }

    return _menuDataAry;
}

- (MenuTabView*)menuView
{
    if (_menuView == nil) {
        _menuView = [[MenuTabView alloc] initMenuWithTitles:self.menuDataAry withFrame:CGRectMake(0, 0, self.view.frame.size.width, 40) isShowSeparator:YES];
        _menuView.delegate = self;
    }

    return _menuView;
}

- (UIScrollView*)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setBounces:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width * [self.menuDataAry count], self.view.frame.size.height - 40)];
        [_scrollView setBackgroundColor:kDefaultVCBackgroundColor];
        _scrollView.delegate = self;
        _scrollView.delaysContentTouches = NO;
    }

    return _scrollView;
}

- (GYHSLoginViewController*)hsUserVC
{
    if (_hsUserVC == nil) {
        _hsUserVC = [[GYHSLoginViewController alloc] init];
        _hsUserVC.loginType = GYHSLoginViewControllerTypeHashsCard;
        _hsUserVC.pageType = self.pageType;
        _hsUserVC.popType = self.popType;
    }

    return _hsUserVC;
}

- (GYHSLoginViewController*)noCardUserVC
{
    if (_noCardUserVC == nil) {
        _noCardUserVC = [[GYHSLoginViewController alloc] init];
        _noCardUserVC.loginType = GYHSLoginViewControllerTypeNohsCard;
        _noCardUserVC.pageType = self.pageType;
        _noCardUserVC.popType = self.popType;
    }

    return _noCardUserVC;
}

@end
