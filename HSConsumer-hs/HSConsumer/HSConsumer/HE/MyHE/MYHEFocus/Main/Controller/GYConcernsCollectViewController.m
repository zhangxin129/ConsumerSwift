//
//  GYConcernsCollectViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYConcernsCollectViewController.h"
#import "GYEasybuyMainViewController.h"
#import "MenuTabView.h"
#import "GYConcernsCollectGoodsViewController.h"
#import "GYConcernsCollectShopsViewController.h"

@interface GYConcernsCollectViewController () <UIScrollViewDelegate, MenuTabViewDelegate>

@property (nonatomic, strong) MenuTabView* menu; //菜单视图
@property (nonatomic, strong) NSArray* menuTitles; //菜单标题数组
@property (nonatomic, strong) NSMutableArray* arrParentViews; //parentView array
@property (weak, nonatomic) IBOutlet UIScrollView* scrollV; //滚动视图，用于装载各vc view
@end

@implementation GYConcernsCollectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    _index = 0;
    _menuTitles = @[ kLocalized(@"GYHE_MyHE_Goods"),
        kLocalized(@"GYHE_MyHE_Shop") ];
    [_scrollV setPagingEnabled:YES];
    [_scrollV setBounces:NO];
    _scrollV.scrollEnabled = NO;
    [_scrollV setShowsVerticalScrollIndicator:NO];
    _scrollV.delegate = self;
    // m by lizp
    [_scrollV setContentSize:CGSizeMake(kScreenWidth * _menuTitles.count, 150)];
    [_scrollV setBackgroundColor:kDefaultVCBackgroundColor];
    //添加 tableview
    _arrParentViews = [NSMutableArray array];
    CGRect tableViewFrame = CGRectMake(0, 0, kScreenWidth, _scrollV.bounds.size.height);
    GYConcernsCollectGoodsViewController* concernsCollectGoods = kLoadVcFromClassStringName(NSStringFromClass([GYConcernsCollectGoodsViewController class]));
    concernsCollectGoods.nav = self.navigationController;
    concernsCollectGoods.view.frame = tableViewFrame;
    [_scrollV addSubview:concernsCollectGoods.view];
    [_arrParentViews addObject:concernsCollectGoods];
    [self addChildViewController:concernsCollectGoods];
    tableViewFrame.origin.x += tableViewFrame.size.width;
    GYConcernsCollectShopsViewController* concernsCollectShops = kLoadVcFromClassStringName(NSStringFromClass([GYConcernsCollectShopsViewController class]));
    concernsCollectShops.nav = self.navigationController;
    concernsCollectShops.view.frame = tableViewFrame;
    [_scrollV addSubview:concernsCollectShops.view];
    [_arrParentViews addObject:concernsCollectShops];
    [self addChildViewController:concernsCollectShops];
    //    标题不可点,改cell为shopcell
    //初始化menu
    _menu = [[MenuTabView alloc] initMenuWithTitles:_menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    _menu.delegate = self;
    //必须设置menu的delegate 及 _scrollV delegate后才可以设置默认显示
    [_menu setDefaultItem:self.index % 2];
    [self.view addSubview:_menu];
    [(GYConcernsCollectGoodsViewController*)_arrParentViews[0] setBtnMenu:[_menu getItemButton:0]];
    [(GYConcernsCollectGoodsViewController*)_arrParentViews[1] setBtnMenu:[_menu getItemButton:1]];
    //设置商铺的菜单title
    concernsCollectShops.block = ^(NSInteger index, NSString* title) {
        [self setMenuIndex:index withTitle:title];
    };
    //设置商品的菜单title
    concernsCollectGoods.block = ^(NSInteger index, NSString* title) {
        [self setMenuIndex:index withTitle:title];
    };
}

//设置菜单角标数
- (void)setMenuIndex:(NSInteger)index withTitle:(NSString*)title
{
    [_menu setNewTitle:title withIndex:index];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) { //返回
        if ([self.navigationController.topViewController isKindOfClass:[GYEasybuyMainViewController class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            ;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - GYViewControllerDelegate

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self.navigationController pushViewController:vc animated:ani];
}

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    //m by lizp
    CGPoint off_set = CGPointMake(index * self.view.bounds.size.width, _scrollV.contentOffset.y);
    _scrollV.contentOffset = off_set;
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
                [_menu updateMenu:index + 1];
            }
        } else {
            [_menu updateMenu:index];
        }
    }
}

@end
