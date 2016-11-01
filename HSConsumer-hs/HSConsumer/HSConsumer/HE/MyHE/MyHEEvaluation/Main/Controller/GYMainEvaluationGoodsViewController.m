//
//  GYMainEvaluationGoodsViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
//全部订单
#define kCellSubCellHeight 80.f

#import "GYMainEvaluationGoodsViewController.h"
#import "MenuTabView.h"
#import "GYEvaluationGoodsViewController.h"
#import "GYAlreadyEvaluateGoodsViewController.h"
#import "GYEasybuyMainViewController.h"

@interface GYMainEvaluationGoodsViewController () <UIScrollViewDelegate, MenuTabViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView* scrollV; //滚动视图，用于装载各vc view
@property (nonatomic, strong) MenuTabView* menu; //菜单视图
@property (nonatomic, strong) NSArray* menuTitles; //菜单标题数组
@property (nonatomic, strong) NSMutableArray* arrParentViews; //parentView array
@property (nonatomic, strong) GYAlreadyEvaluateGoodsViewController* vcFiniedEvaluationGoods;
@property (nonatomic, strong) GYEvaluationGoodsViewController* vcUnfiniedEvaluationGoods;

@end

@implementation GYMainEvaluationGoodsViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _index = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    _menuTitles = @[ kLocalized(@"GYHE_MyHE_AlreadyEvaluate"),
        kLocalized(@"GYHE_MyHE_WaitEvaluation") ];
    [_scrollV setPagingEnabled:YES];
    [_scrollV setBounces:NO];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    _scrollV.delegate = self;
    [_scrollV setContentSize:CGSizeMake(kScreenWidth * _menuTitles.count, 150)];
    [_scrollV setBackgroundColor:kDefaultVCBackgroundColor];
    //添加 tableview
    _vcFiniedEvaluationGoods = kLoadVcFromClassStringName(NSStringFromClass([GYAlreadyEvaluateGoodsViewController class]));
    _vcUnfiniedEvaluationGoods = kLoadVcFromClassStringName(NSStringFromClass([GYEvaluationGoodsViewController class]));
    _arrParentViews = [@[ _vcFiniedEvaluationGoods, _vcUnfiniedEvaluationGoods ] mutableCopy];
    CGRect tableViewFrame = CGRectMake(0, 0, kScreenWidth, _scrollV.bounds.size.height);
    for (int i = 0; i < _menuTitles.count; i++) {
        tableViewFrame.origin.x = kScreenWidth * i;
        GYEvaluationGoodsViewController* vc = _arrParentViews[i];
        vc.nav = self.navigationController;
        vc.view.frame = tableViewFrame;
        [_scrollV addSubview:vc.view];
    }
    _menu = [[MenuTabView alloc] initMenuWithTitles:_menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    _menu.delegate = self;
    //必须设置menu的delegate 及 _scrollV delegate后才可以设置默认显示
    [_menu setDefaultItem:self.index % 2];
    [self.view addSubview:_menu];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) { //返回
        if ([self.navigationController.topViewController isKindOfClass:[GYEasybuyMainViewController class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -GYViewControllerDelegate
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self.navigationController pushViewController:vc animated:ani];
}

#pragma mark -MenuTabViewDelegate
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
                [_menu updateMenu:index + 1];
            }
        } else {
            [_menu updateMenu:index];
        }
    }
}

@end
