//
//  GYEPMyAllOrdersViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  消费抵扣券账户控制器

#import "GYEPMyCouponsMainViewController.h"
#import "MenuTabView.h"

#import "GYEasybuyMainViewController.h"
#import "GYEPMyCouponsViewController.h"

@interface GYEPMyCouponsMainViewController () <UIScrollViewDelegate, MenuTabViewDelegate> {
    MenuTabView* menu; //菜单视图
    NSArray* menuTitles; //菜单标题数组
    NSMutableArray* arrParentViews; //parentView array
}

@property (nonatomic, strong) NSMutableArray* arrResult;
//滚动视图，用于装载各vc view
@property (nonatomic, strong) UIScrollView* scrollV;

@end

@implementation GYEPMyCouponsMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    menuTitles = @[ kLocalized(@"GYHS_MyAccounts_can_use"),
        kLocalized(@"GYHS_MyAccounts_already_use"),
    ];

    [self.scrollV setPagingEnabled:YES];
    [self.scrollV setBounces:NO];
    [self.scrollV setShowsHorizontalScrollIndicator:NO];

    [self.scrollV setContentSize:CGSizeMake(kScreenWidth * menuTitles.count, 150)];
    [self.scrollV setBackgroundColor:kDefaultVCBackgroundColor];

    //添加 tableview
    arrParentViews = [NSMutableArray array];

    CGRect tableViewFrame = _scrollV.bounds;

    GYEPMyCouponsViewController* tmpVc = nil;
    tmpVc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyCouponsViewController class]));
    tmpVc.firstTipsErr = YES;
    tmpVc.couponsType = kCouponsTypeUnUse;
    tmpVc.nav = self.navigationController;
    tmpVc.view.frame = tableViewFrame;
    [self.scrollV addSubview:tmpVc.view];
    [arrParentViews addObject:tmpVc];

    tableViewFrame.origin.x += tableViewFrame.size.width;
    tmpVc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyCouponsViewController class]));
    tmpVc.firstTipsErr = NO;
    tmpVc.couponsType = kCouponsTypeUsed;
    tmpVc.nav = self.navigationController;
    tmpVc.view.frame = tableViewFrame;
    [self.scrollV addSubview:tmpVc.view];
    [arrParentViews addObject:tmpVc];

    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    menu.delegate = self;

    [self.view addSubview:menu];
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
    //设置当前导航条标题
    //    [self.navigationItem setTitle:menuTitles[index]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == _scrollV) { //因为tableview 中的scrollView 也使用同一代理，所以要判断，否则取得x值不是预期的
        CGFloat _x = scrollView.contentOffset.x; //滑动的即时位置x坐标值
        NSInteger index = (NSInteger)(_x / self.view.frame.size.width); //所偶数当前视图

        //设置滑动过渡位置
        if (index < menu.selectedIndex) {
            if (_x < menu.selectedIndex * self.view.frame.size.width - 0.5 * self.view.frame.size.width) {
                [menu updateMenu:index];
            }
        }
        else if (index == menu.selectedIndex) {
            if (_x > menu.selectedIndex * self.view.frame.size.width + 0.5 * self.view.frame.size.width) {
                [menu updateMenu:index + 1];
            }
        }
        else {
            [menu updateMenu:index];
        }
    }
}
#pragma mark--懒加载
- (UIScrollView*)scrollV
{

    if (!_scrollV) {
        
        _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth, kScreenHeight)];
        _scrollV.delegate = self;
        [self.view addSubview:_scrollV];
    }
    return _scrollV;
}

@end
