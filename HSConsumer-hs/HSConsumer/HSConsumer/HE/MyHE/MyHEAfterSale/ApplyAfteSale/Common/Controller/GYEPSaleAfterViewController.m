//
//  GYEPSaleAfterViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved

//全部订单
#define kCellSubCellHeight 80.f
#import "GYEPSaleAfterViewController.h"
#import "MenuTabView.h"
#import "GYEasybuyMainViewController.h"
#import "GYEPMyOrderViewController.h"

@interface GYEPSaleAfterViewController () <UIScrollViewDelegate, MenuTabViewDelegate>

@property (nonatomic, strong) NSMutableArray* arrResult;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) UIScrollView* scrollV;
@property (nonatomic, strong) NSMutableArray* arrParentViews;
@property (nonatomic, strong) NSArray* menuTitles; //菜单标题数组
@property (nonatomic, strong) MenuTabView* menu; //菜单视图

@end

@implementation GYEPSaleAfterViewController

- (UIScrollView*)scrollV
{
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth, kScreenHeight)];
        _scrollV.delegate = self;
        [self.view addSubview:_scrollV];
    }
    return _scrollV;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    self.isFirst = YES;
    _menuTitles = @[ kLocalized(@"GYHE_MyHE_ApplyAfterSales"),
        kLocalized(@"GYHE_MyHE_ReturnChangeGoodsRecord") ];
    [self.scrollV setPagingEnabled:YES];
    [self.scrollV setBounces:NO];
    [self.scrollV setShowsHorizontalScrollIndicator:NO];
    [self.scrollV setContentSize:CGSizeMake(kScreenWidth * _menuTitles.count, 150)];
    [self.scrollV setBackgroundColor:kDefaultVCBackgroundColor];
    //添加 tableview
    _arrParentViews = [NSMutableArray array];
    CGRect tableViewFrame = CGRectMake(0, 0, kScreenWidth, _scrollV.bounds.size.height);
    GYEPMyOrderViewController* order = nil;
    order = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
    order.isQueryRefundRecord = NO;
    order.isSaleAfter = YES;
    order.orderState = kOrderStateFinished;
    order.nav = self.navigationController;
    order.view.frame = tableViewFrame;
    [self.scrollV addSubview:order.view];
    [_arrParentViews addObject:order];
    tableViewFrame.origin.x += tableViewFrame.size.width;
    order = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
    //order.orderState = kOrderStateWaittingPay;
    order.isQueryRefundRecord = YES;
    order.isSaleAfter = YES;
    order.nav = self.navigationController;
    order.view.frame = tableViewFrame;
    [_scrollV addSubview:order.view];
    [_arrParentViews addObject:order];
    _menu = [[MenuTabView alloc] initMenuWithTitles:_menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    _menu.delegate = self;
    [self.view addSubview:_menu];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        if ([self.navigationController.topViewController isKindOfClass:[GYEasybuyMainViewController class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    if (self.isFirst) { // 如果是经过viewDidLoad进来的话，就不刷新数据，因为那两个页面本身就是在viewDidLoad里面刷新一次。
        self.isFirst = NO;
    }
    else { // 让它pop回来时刷新两个页面的数据
        for (GYEPMyOrderViewController* orderVC in _arrParentViews) {
            [orderVC headerRereshing];
        }
    }
}

#pragma mark - xxx

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self.navigationController pushViewController:vc animated:ani];
}

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    CGFloat contentOffsetX = _scrollV.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
    if (viewIndex == index)
        return;
    CGFloat _x = _scrollV.frame.size.width * index;
    [_scrollV scrollRectToVisible:CGRectMake(_x,
                                      _scrollV.frame.origin.y,
                                      _scrollV.frame.size.width,
                                      _scrollV.frame.size.height)
                         animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == _scrollV) { //因为tableview 中的scrollView 也使用同一代理，所以要判断，否则取得x值不是预期的
        CGFloat _x = scrollView.contentOffset.x; //滑动的即时位置x坐标值
        NSInteger index = (NSInteger)(_x / self.view.frame.size.width); //所偶数当前视图
        //设置滑动过渡位置
        if (index < _menu.selectedIndex) {
            if (_x < _menu.selectedIndex * self.view.frame.size.width - 0.5 * self.view.frame.size.width) {
                [_menu updateMenu:index];
            }
        }
        else if (index == _menu.selectedIndex) {
            if (_x > _menu.selectedIndex * self.view.frame.size.width + 0.5 * self.view.frame.size.width) {
                [_menu updateMenu:index + 1];;
            }
        } else {
            [_menu updateMenu:index];
        }
    }
}

@end
